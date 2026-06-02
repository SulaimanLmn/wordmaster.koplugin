# Word Mastery Colorizer (wordmaster.koplugin)

Colorizes your Vocabulary Builder highlights based on mastery level.

When you look up words in KOReader, they're added to the Vocabulary Builder with spaced repetition reviews. This plugin reads your vocab data and updates the highlight colors to show your progress at a glance.

## Color Scheme

| Color  | Meaning                    | Streak Count |
|--------|----------------------------|--------------|
| Red    | New / Forgot the word      | 0            |
| Yellow | Learning (in progress)     | 1–4          |
| Green  | Mastered (got it right)    | 5+           |

## Installation

1. Copy `wordmaster.koplugin/` into the `plugins/` directory on your Kindle (next to other `.koplugin` folders)
2. Restart KOReader
3. Open Tools → Word Mastery → Colorize Vocab Highlights

## Usage

1. Build up vocabulary by looking up words in the reader (auto-added to Vocabulary Builder)
2. Review words in Vocabulary Builder (Got it / Forgot buttons)
3. Run **Tools → Word Mastery → Colorize Vocab Highlights** to update highlight colors
4. Highlights in the current document will change to red/yellow/green based on mastery

## Requirements

- KOReader with the built-in Vocabulary Builder plugin enabled
- Words must be added to the Vocabulary Builder (via dictionary lookups or manual add)
- Works per-document: run the colorizer in each document where you have vocab highlights

## How It Works

- Reads the Vocabulary Builder's SQLite database to get word mastery data (`streak_count`)
- Scans all highlights in the current document
- Matches highlight text against vocab words
- Updates highlight colors to reflect mastery level
- Saves changes to the document's annotation settings
