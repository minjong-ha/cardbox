# Cardbox

Cardbox is an iOS application project.
It focuses on providing encrypted short card with clear UI/UX.


## File Description
CardBox: xcode project directory


## Overview

Cardbox provides card management for the users.
It is clear that there are thousands of card application in store.
However, since there is no satisfying card app for me, I decide to create my own one.
The name of "Cardbox" is a combination of manuscript and secret.
The basic concept of it is a card sorting box, such as hand-written card.
Thus, the convenience is not our highest priority, it is more important to transplant the feeling of cards.
Since its difficulty and non-profitable buissness model, there will be no commercials or advertisements (only a simple donate method for me).
I also plan to open the source codes.


There are two sections: public and private.

In public section, the contents of the card are not encrypted and sharable (for now, I plan to support Airdrop only).
User can write and read just like the other files.

However, in private section, each contents are encrypted.
I am envisioning various approaches, but the common feature is that only the title (or tag) is non-encrpyted, and decrypting contents requires security check such as FaceID or TouchID.
Only after the users pass the security check, they could read their cards.
Users can enroll their key when their first sign-in.
I am still thinking about the efficient and acceptable decrypt policy and mechanism.
For the incremental implementation, My plan is following the below blueprint.


  > * The contents are written in plain text, and they will be shown up when users click the private section or each cards. 
  The first enrolled key is used for decrpytion.

  > * The contents are written in crypt text. 
  The key is located in the server, and users send request to acquire key or send crpyt text to server.
  The text will be translated in the local device or server.
  The plain text will never exist in both machine and server, except the time users decrypt it.
  (Optional, users decide where the encrpyted cards are.
   It could be local, or cloud.)


The implementation could be changed.


### 1. Public Section

Every cards are the plain texts, and each cards is sharable using Airdrop.
The reason that Cardbox only supports Airdrop is the concept of the app is a manuscript, which is retro or classic or out-dated.


### 2. Private Section  

#### Deployment

In private section, there are two options for users.
One is "local", and another is "cloud".
The "local" parameter enables users could keep their cards only in the local machine.
The "cloud" parameter enables users could sync their cards with the server (it could be the icloud).


### 3. Notes

Each cards has its name, tag, day and etc.
One of the interesting parts of card is it automatically resize the texts depending on its size.
Less the texts are, clearer the character is.
Moreover, Cardbox does not support modifying the contents. 
It only supports append feature.


### 4. Sorting

Cardbox supports powerful sorting functions.
  > * Users can sort the cards depending on its title.
  > * Users can extract the cards containing specific keyword__s__.


### 5. Possible features?

  > * write location info where the card created? updated?

## Development Environment
  * Xcode 13
  * SwiftUI 


## Used Libraries
  * https://github.com/realm/realm-swift (RealmSwift): mobile database 
  * https://github.com/Ramotion/folding-cell (FoldingCell)


## Libraries keep an eye on
  * https://github.com/jogendra/LoadingShimmer
  * https://github.com/Ramotion/animated-tab-bar 
  * https://github.com/Ramotion/paper-switch: local/cloud indicator candidate
  * https://github.com/Ramotion/fluid-slider (android support)
  * https://github.com/Ramotion/garland-view : card representation candidate
