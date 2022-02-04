# SecretMemo

SecretMemo is an iOS application project.
It focuses on providing encrypted short memo with clear UI/UX.


##Overview

SecretMemo provides memo management for the users.
Since there is no satisfying memo app for me, I decide create my own one.
Since its difficulty and non profitable buissness model, there will be no commercials and advertisements, only a simple donate method for me.
And, I plan to open the source codes.

There are public and private section.
In public section, the contents of the memo are not encrypted and sharable (for now, I plan to support Airdrop only).
User can write and read just like the other files.

However, in private section, each contents are encrypted. 
Only the title (or tag) is non-encrpyted, and decrypting contents requires security check such as FaceID or TouchID.
When the user pass the security check, the main server send the decrpytion key and the contents will be decrypted.


