# Telestrations
A recreation of the classic game of Telestrations. Created with Dart and Flutter for Web

## About the Game
### How to Play
1. Game begins by having all players put down a short phrase or word
2. Each player's input is transferred to the next player in the sequence
3. Each player is tasked with drawing an image based on the input they recieved
4. This image is then transferred to the next player in the sequence
5. Players then have to guess what word/phrase the image was trying to describe
6. This cycle continues until every player contributes a word or picture to each phrase.

### Notes
* Players are only allowed to see the phrase/image they were given and the phrase/image that they create in response
* No player should only see each set once

## Technical Details
### Progress
 - [X] Game Lobbies
 - [ ] Guessing Images
 - [X] Drawing Images
 - [ ] Saving Images
 - [ ] Game Logic
 
 ### Blockers
 * Currently challenging to transfer image to other players
   * Getting an image from a Canvas is not currently implemented in Flutter for Web
   * List of lines drawn grows too fast to be efficiently transferred between players
 * Lack of plugins for Flutter for Web
