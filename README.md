# SecretMemo

SecretMemo is an iOS application project.
It focuses on providing encrypted short memo with clear UI/UX.


##Overview

SecretMemo provides memo management for the users.
Since there is no satisfying memo app for me, I decide to create my own one.
Since its difficulty and non-profitable buissness model, there will be no commercials and advertisements, only a simple donate method for me.
I also plan to open the source codes.

There are public and private sections.
In public section, the contents of the memo are not encrypted and sharable (for now, I plan to support Airdrop only).
User can write and read just like the other files.

However, in private section, each contents are encrypted.
I am envisioning various approaches, but the common feature is that only the title (or tag) is non-encrpyted, and decrypting contents requires security check such as FaceID or TouchID.
Only after the users pass the security check, they could read their memos.
Users can enroll the key when their first sign-in.
I am still thinking about the efficient and acceptable decrypt policy and mechanism.
For the incremental implement, My plan is following the below blueprint.

  > * 1. The contents are written in plain text, and they will be shown up when users click the private section or each memos. 
  The first enrolled key is used for decrpytion.
  > * 2. The contents are written in crypt text. 
  The key is located in the server, and users send request to acquire key or send crpyt text to server.
  The text will be translated in the local device or server.

The implementation could be changed.


##Keeping an eye on Libraries
  1. https://github.com/jogendra/LoadingShimmer
  2. https://github.com/Ramotion/folding-cell
  3. https://github.com/Ramotion/animated-tab-bar
  4. https://github.com/Ramotion/paper-switch
  5. https://github.com/Ramotion/fluid-slider
