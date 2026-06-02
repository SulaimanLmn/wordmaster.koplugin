# Word Mastery Colorizer

A KOReader plugin that colorizes your Vocabulary Builder highlights based on how well you know each word.

When you review words in the Vocabulary Builder (tapping "Got it" or "Forgot"), this plugin reads your progress and updates the highlight color in your book so you can see at a glance which words need more practice.

## Color Scheme

| Color  | Meaning                    | Streak Count | When It Appears |
|--------|----------------------------|--------------|-----------------|
| Red    | New or forgot the word     | 0            | You just added the word or tapped "Forgot" |
| Yellow | Learning (in progress)     | 1–4          | You've gotten it right a few times, still practicing |
| Green  | Mastered                   | 5+           | You've consistently remembered the word |

## Prerequisites

- KOReader installed on your Kindle (or other device)
- The built-in **Vocabulary Builder** plugin enabled (it's enabled by default)
- At least one word added to your Vocabulary Builder (via dictionary lookup while reading)

## Installation

1. Connect your Kindle to your computer via USB.
2. Navigate to the `koreader/plugins/` folder on your Kindle.
3. Copy the entire `wordmaster.koplugin/` folder into `koreader/plugins/`.
4. Eject your Kindle safely.
5. Restart KOReader (fully close and reopen, or use the Restart menu option).
6. Open any book, then tap the **Tools** (wrench) icon → **Word Mastery** — you should see the menu entry.

## Usage — Step by Step

### Step 1: Build Your Vocabulary

While reading a book in KOReader:
1. Long-press on a word you want to learn.
2. Tap **Dictionary** to look it up.
3. Close the dictionary — the word is automatically added to your Vocabulary Builder.

### Step 2: Review Your Words

1. Open the Vocabulary Builder: **Tools → Vocabulary Builder**.
2. You'll see a list of words you've looked up.
3. Tap **Got it** if you remember the word, or **Forgot** if you don't.
4. Do this regularly — the built-in spaced repetition system schedules reviews for you.

### Step 3: Colorize Your Highlights

1. Open a book that has vocabulary highlights.
2. Go to **Tools → Word Mastery → Colorize Vocab Highlights**.
3. A popup will show you how many highlights were updated:
   ```
   Updated 12 highlights:
     Red (new): 5
     Yellow (learning): 4
     Green (mastered): 3
   ```
4. The highlights in your book immediately change to show your mastery level.

### Step 4: Repeat

- After each review session in the Vocabulary Builder, run **Colorize Vocab Highlights** again.
- The colors will update to reflect your new progress.

## Tips

- Run the colorizer **per-book**. Each document has its own set of highlights, so you need to run it in every book where you have vocabulary highlights.
- The colorizer matches your vocab words against **all highlights** in the book, not just the ones that were auto-added by the dictionary. If you highlighted a sentence containing a vocab word, that highlight will also be colorized.
- To see your progress at a glance, flip through pages after colorizing — red and yellow highlights stand out and remind you to review.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "No vocabulary words found" | Open the Vocabulary Builder and make sure it has words. Look up a word in a book first. |
| "No highlights matched" | The words in your vocab list don't appear in any highlights in this book. Highlight some text containing your vocab words, then run again. |
| "Database not found" | The Vocabulary Builder plugin hasn't been used yet. Look up at least one word in a book to initialize it. |
| Colors didn't change | Make sure you tapped "Got it" or "Forgot" in the Vocabulary Builder *before* running the colorizer. The color is based on your review history. |

## How It Works

1. Reads the Vocabulary Builder's SQLite database at `koreader/settings/vocabulary_builder.sqlite3` to get each word's `streak_count` (how many times in a row you've answered correctly).
2. Opens the current document's highlight annotations.
3. Matches each highlight's text against your vocabulary words (case-insensitive).
4. Updates the highlight color based on the word's streak threshold:
   - 0 → red
   - 1–4 → yellow
   - 5+ → green
5. Saves the updated colors and refreshes the display.

## License

This plugin is provided as-is under the AGPLv3 license (same as KOReader).
