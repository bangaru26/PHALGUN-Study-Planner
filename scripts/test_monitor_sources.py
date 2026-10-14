#!/usr/bin/env python3
"""Regression tests for PHALGUN source-change previews."""
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from monitor_sources import TextExtractor, change_preview, normalize_text


class SourceMonitorTests(unittest.TestCase):
    def test_changed_sentences_are_split_and_rendered_on_separate_lines(self):
        old = "The old filing date is 1 April. This sentence stays the same."
        new = "The new filing date is 1 July. This sentence stays the same."
        preview = change_preview(old, new)
        self.assertIn("- The old filing date is 1 April.", preview)
        self.assertIn("+ The new filing date is 1 July.", preview)
        self.assertIn("\n", preview)
        self.assertNotIn("\\n", preview)

    def test_preview_shows_changed_words_with_nearby_context(self):
        old = " ".join(["stable navigation"] * 30) + " filing deadline is 1 April " + " ".join(["stable footer"] * 30)
        new = " ".join(["stable navigation"] * 30) + " filing deadline is 1 July " + " ".join(["stable footer"] * 30)
        preview = change_preview(old, new)
        self.assertIn("1 April", preview)
        self.assertIn("1 July", preview)
        self.assertNotIn("\\n", preview)

    def test_visitor_counter_changes_do_not_trigger_source_changes(self):
        old = "Official page. Visitors Count 482798 QUICK LINKS"
        new = "Official page. Visitors Count 482799 QUICK LINKS"
        self.assertEqual(normalize_text(old), normalize_text(new))

    def test_missing_snapshot_is_explicit(self):
        self.assertEqual(change_preview("", "A new official notice."), "No prior text snapshot is available for comparison.")

    def test_html_extractor_ignores_scripts_and_styles(self):
        parser = TextExtractor()
        parser.feed("<html><style>hidden style</style><script>hidden script</script><p>Visible notice.</p></html>")
        extracted = " ".join(parser.parts)
        self.assertIn("Visible notice.", extracted)
        self.assertNotIn("hidden style", extracted)
        self.assertNotIn("hidden script", extracted)


if __name__ == "__main__":
    unittest.main(verbosity=2)
