#!/usr/bin/env python3
"""PHALGUN source-change watch. A fingerprint change is a review flag, not legal advice."""
import hashlib, html, json, os, re, sys, time
from datetime import datetime, timezone
from html.parser import HTMLParser
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CATALOG = os.path.join(ROOT, "monitoring", "source-catalog.json")
STATE = os.path.join(ROOT, "monitoring", "state.json")
REPORT_JSON = os.path.join(ROOT, "monitoring", "latest-report.json")
REPORT_MD = os.path.join(ROOT, "monitoring", "CHANGE-LOG.md")

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__(); self.parts=[]; self.skip=0
    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style", "noscript", "svg"): self.skip += 1
    def handle_endtag(self, tag):
        if tag in ("script", "style", "noscript", "svg") and self.skip: self.skip -= 1
    def handle_data(self, data):
        if not self.skip:
            s = re.sub(r"\s+", " ", data).strip()
            if s: self.parts.append(s)

def fetch(url):
    req = Request(url, headers={"User-Agent":"PHALGUN-SourceWatch/1.0 (+educational change detection)", "Accept":"text/html,application/xhtml+xml"})
    with urlopen(req, timeout=25) as response:
        body = response.read(3_000_000)
        charset = response.headers.get_content_charset() or "utf-8"
        raw = body.decode(charset, errors="replace")
        parser = TextExtractor(); parser.feed(raw)
        text = re.sub(r"\s+", " ", " ".join(parser.parts)).strip()
        if not text: text = re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", raw)).strip()
        title_match = re.search(r"<title[^>]*>(.*?)</title>", raw, re.I|re.S)
        title = html.unescape(re.sub(r"<[^>]+>", "", title_match.group(1))).strip() if title_match else ""
        return {"status":"ok","http_status":response.status,"final_url":response.geturl(),
                "title":title[:300],"fingerprint":hashlib.sha256(text.encode("utf-8")).hexdigest(),
                "excerpt":text[:500],"text_length":len(text)}

def main():
    with open(CATALOG, encoding="utf-8") as f: catalog=json.load(f)
    try:
        with open(STATE, encoding="utf-8") as f: previous=json.load(f)
    except (OSError, json.JSONDecodeError): previous={"sources":{}}
    now=datetime.now(timezone.utc).isoformat(timespec="seconds")
    old=previous.get("sources",{}); current={}; results=[]
    for source in catalog["sources"]:
        sid=source["id"]
        try:
            obs=fetch(source["url"])
            prior=old.get(sid,{})
            if not prior: status="BASELINE"
            elif prior.get("fingerprint")==obs["fingerprint"]: status="UNCHANGED"
            else: status="CHANGED — REVIEW REQUIRED"
            obs["checked_at"]=now
            current[sid]={**obs,"topic":source["topic"],"authority":source["authority"],"url":source["url"]}
            results.append({**source,**obs,"status":status,
                "previous_fingerprint":prior.get("fingerprint"),
                "previous_excerpt":prior.get("excerpt","")})
            time.sleep(1)
        except Exception as e:
            prior=old.get(sid,{})
            failed={"status":"UNAVAILABLE","checked_at":now,"error":f"{type(e).__name__}: {str(e)[:250]}",
                    "topic":source["topic"],"authority":source["authority"],"url":source["url"]}
            current[sid]={**prior,**failed}
            results.append({**source,**failed,"previous_fingerprint":prior.get("fingerprint"),
                            "previous_excerpt":prior.get("excerpt","")})
    report={"generated_at":now,"scope":"Page-level fingerprint watch; not a legal or semantic determination.",
            "summary":{"changed":sum(r["status"].startswith("CHANGED") for r in results),
                       "unchanged":sum(r["status"]=="UNCHANGED" for r in results),
                       "baseline":sum(r["status"]=="BASELINE" for r in results),
                       "unavailable":sum(r["status"]=="UNAVAILABLE" for r in results)},
            "results":results,"review_policy":catalog["policy"]}
    os.makedirs(os.path.dirname(STATE),exist_ok=True)
    with open(STATE,"w",encoding="utf-8") as f: json.dump({"updated_at":now,"sources":current},f,indent=2,ensure_ascii=False)
    with open(REPORT_JSON,"w",encoding="utf-8") as f: json.dump(report,f,indent=2,ensure_ascii=False)
    lines=["# PHALGUN Source Change Log","",f"Last check: {now} (UTC)","",
           "**Important:** a page fingerprint change is a review flag, not proof that a rule changed. An unchanged fingerprint means only that this fetched page looked the same as the previous successful check. Check official notices, effective dates, jurisdiction and affected lessons before changing learning content.","",
           f"Summary: {report['summary']['changed']} changed; {report['summary']['unchanged']} unchanged; {report['summary']['baseline']} baseline; {report['summary']['unavailable']} unavailable.","",
           "| Status | Topic | Authority | Check |", "|---|---|---|---|"]
    for r in results:
        lines.append(f"| {r['status']} | {r['topic']} | {r['authority']} | [Open source]({r['url']}) |")
        if r["status"].startswith("CHANGED"):
            lines += [f"",f"### Review required — {r['topic']}",f"- Previous page excerpt: {r.get('previous_excerpt') or 'No prior snapshot'}",
                      f"- Current page excerpt: {r.get('excerpt') or 'No text extracted'}",
                      "- **Rule/effective date/lesson impact:** Not yet determined; human or domain-specific verification required.",""]
        elif r["status"]=="UNAVAILABLE":
            lines.append(f"  - Fetch issue: {r.get('error','unknown error')}")
    lines += ["","## What remains unchanged?","For each source marked **UNCHANGED**, the fetched page text fingerprint matched the previous successful check. This is not a guarantee that every related regulation, product release, linked PDF, or subpage is unchanged.","",
              "## Change-control rule","Do not overwrite a lesson solely because this monitor flags a page. Record the official notice/version, publication and effective dates, jurisdiction, affected lesson/assessment IDs, prior rule, new rule, and reviewer status. Keep the old lesson version available for historical study."]
    with open(REPORT_MD,"w",encoding="utf-8") as f: f.write("\n".join(lines)+"\n")
    print(json.dumps(report["summary"],ensure_ascii=False))
    if report["summary"]["unavailable"] == len(results):
        print("WARNING: all sources were unavailable; the report will still be published and must not be interpreted as unchanged.",file=sys.stderr)
if __name__=="__main__": main()
