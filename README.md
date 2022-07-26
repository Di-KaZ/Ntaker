# N Taker

Small note taking app poorly made with Flutter 😎

## Some screenshots

![NTaker](https://raw.githubusercontent.com/Di-KaZ/Ntaker/develop/sreenshots/ntaker.gif)
![NTaker2](https://raw.githubusercontent.com/Di-KaZ/Ntaker/develop/sreenshots/ntaker2.gif)

# Features

- Show resume of the note with color of category
- Create note and edit them, add bold, underline and italics
- Delete note with a swipe
- Screen to resume how many notes you have in categories (not fully implemented)
- Settings to toggle on or off autosave
- Add a note to favorites

# Known bugs

- When autosave is enabled, QuillController event listener breaks the focus of the editor and cursor can't figure out why
- Favorite 'tab' does not work on release build need to check why

# Download release
[here](https://github.com/Di-KaZ/Ntaker/releases)

# For Reviewers

Everything went flawlessly i've got one problem with android studio AVD. I had to manually install AMD drivers.

After that I learned the basics of Flutter and dart following the Flutter getting started

## developpement of the apps

I wish I had more time to learn how to user Material Theme properly to theme the app, Styles are all over the place.

There should be a better way to handle routing in the app with Named route but for simplicity and rapidity. I did'nt used it.

Dart syntax is easy to learn I really love using it.

I tried to add the possibility to add multiple tag to one note but it was too much for this small project. The tag views wwas meant to be clickable to see notes inside, and the plus icon could create a new group.

Overall it was a great experience and I look forward playing more with Flutter in the Future !

I hope you like the 'final' product ☺

## release build
I've got stuck on it for two hours, then i saw my properties files was not named correctly... after that the build was successful
# Inspiration

This design in found on Dribble by [Mostafa_taghipour.uix](https://dribbble.com/shots/16811788-Notes-app/attachments/11867269?mode=media)
