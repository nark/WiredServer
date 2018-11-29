# Wired Server Source Code

This repository hosts Wired Server source code. You will find an Xcode project named "WiredServer.xcworkspace" that contains a Wired Server target ready to deploy a 10.10+ compatible application (x64).

## Prerequisites

- Homebrew
- OpenSSL
- Mac OS X 10.8+
- Xcode 4.6+

## How to compile Wired Server

1. Install Homebrew : [https://brew.sh](https://brew.sh)

2. Install OpenSSL with homebrew:

		brew install openssl

1. Get sources on GitHub:

		git clone https://github.com/nark/WiredServer.git
		
2. Move into the sources directory:
		
		cd WiredServer/
		
3. Install requirements using CocoaPods:

		pod install
		
4. Open `WiredServer.xcworkspace` with Xcode

5. Select scheme `Wired Server` and be sure to use "Debug" Build Configuration

6. Launch Build, Wired Server.app should launch automatically when finished


## Troubleshooting

Be sure that "wired" target is listed in Taget Dependencies Build Phases of Wired Server target. If not, add it in order to compile wired binary for Mac.

## License

This code is distributed under BSD license, and it is free for personal or commercial use.
		
- Copyright (c) 2003-2009 Axel Andersson, All rights reserved.
- Copyright (c) 2011-2019 Rafaël Warnault, All rights reserved.
		
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
		
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
		
THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

