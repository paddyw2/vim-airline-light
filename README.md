# Easy-to-customize status line and buffer tabs

Vimscript intented as a springboard for personal tab bar and status line customizations.

A <code>.vimrc</code> lightweight alternative to the Airline or similar plugins. To use, copy and paste the <code>airline-light.vim</code> contents to the end of your <code>.vimrc</code>, and, to recreate the screenshot, change your theme to gruvbox. Alternatively, you can choose to only copy the buffer tab code, or just the status line code - they are mostly independent (except for the theme/setup function).

### References

I used two online references in creating this, and they are referenced in the <code>airline-light.vim</code> file.

### Screenshot

![Screenshot](/screenshots/default.png?raw=true "Default Theme")

To customize, simply read through the code and change colors, functions etc. The default colours are based on the Airline Base16 theme, and the vim theme used is gruvbox (not included in this script).

### Motivation

* To learn more about vimscript and how vim customizations work
* To create a faster alternative to the Airline plugin, that allowed complete customization.
