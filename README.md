# Manusecret

Manusecret is an iOS application project.
It focuses on providing encrypted short note with clear UI/UX.


## Overview

Manusecret provides note management for the users.
It is clear that there are thousands of note application in store.
However, since there is no satisfying note app for me, I decide to create my own one.
The basic concept of the Manusecret is the manuscript, such as hand-written note.
Thus, the convenience is not our highest priority.
Since its difficulty and non-profitable buissness model, there will be no commercials or advertisements (only a simple donate method for me).
I also plan to open the source codes.

There are public and private sections.

In public section, the contents of the note are not encrypted and sharable (for now, I plan to support Airdrop only).
User can write and read just like the other files.

However, in private section, each contents are encrypted.
I am envisioning various approaches, but the common feature is that only the title (or tag) is non-encrpyted, and decrypting contents requires security check such as FaceID or TouchID.
Only after the users pass the security check, they could read their notes.
Users can enroll their key when their first sign-in.
I am still thinking about the efficient and acceptable decrypt policy and mechanism.
For the incremental implementation, My plan is following the below blueprint.

  > * 1. The contents are written in plain text, and they will be shown up when users click the private section or each notes. 
  The first enrolled key is used for decrpytion.

  > * 2. The contents are written in crypt text. 
  The key is located in the server, and users send request to acquire key or send crpyt text to server.
  The text will be translated in the local device or server.
  The plain text will never exist in both machine and server, except the time users decrypt it.
  (Optional, users decide where the encrpyted notes are.
   It could be local, or cloud.)

The implementation could be changed.


### 1. Public Section

Every notes are the plain texts, and each notes is sharable using Airdrop.
The reason that Manusecret only supports Airdrop is the concept of the app is a manuscript, which is retro or classic or out-dated.


### 2. Private Section  

#### Deployment

In private section, there are two options for users.
One is "local", and another is "cloud".
The "local" parameter enables users could keep their notes only in the local machine.
The "cloud" parameter enables users could sync their notes with the server (it could be the icloud).


### 3. Notes

Each notes has its name, tag, day and etc.
One of the interesting parts of note is it automatically resize the texts depending on its size.
Less the texts are, clearer the character is.
Moreover, Manusecret does not support modifying the contents. 
It only supports append feature.

## Used Libraries


## Libraries keep an eye on
  1. https://github.com/jogendra/LoadingShimmer
  2. https://github.com/Ramotion/folding-cell (android support)
  3. https://github.com/Ramotion/animated-tab-bar 
  4. https://github.com/Ramotion/paper-switch
  5. https://github.com/Ramotion/fluid-slider (android support)
