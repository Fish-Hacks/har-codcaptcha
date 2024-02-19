![image](https://github.com/Fish-Hacks/har-codcaptcha/assets/36725840/f2261d84-4af1-4d46-9bc6-65829e5e8867)

Links: [DevPost](https://devpost.com/software/cod-captcha-u701hs) | [Local Server](https://my.localserver.app/fish)

# Inspiration
Captcha. <br/>
No like seriously have you tried solving one, they're getting ridiculously difficult. Am I a robot? <br/>
We hate captcha, we hate life. Let's make it even harder to browse the internet to promote going outside.<br/>
Evidently, we hate writing rhymes too.

# What it does
> TLDR : Make solving captcha and proving you are a human even harder than it needs to be. <br/>
> For every megabyte queried on your system, the user would have to solve 1 captcha.

1. Every 10 seconds we get the aggregate of your network logs
2. For every megabyte of data sent/received, you will have to solve a CAPTCHA to prove you are a human
3. A pop up takes over your entire device and hides all other running applications (this forces you to solve the CAPTCHA, we can't have robots take over the world)
4. Solve a series of CAPTCHAs


# Features
- **Selecting images**: Inspired by the CAPTCHAs found online, but these images are all generated with Stable Diffusion.
- **Pupil verification**: We honestly thought it would be really funny if people stared at their webcams with a 2-3cm distance. Can confirm, it was very funny.
- **Scissors Paper Stone**: Use your camera to play a game of scissors paper stone to verify you're a human! I mean, obviously only humans can win at that game. We're honestly surprised how accurate this hand recognition model we trained in less than an hour is.
- **Where's Waldo**: Select the square where Waldo is in. It's a fun game :)
- *Surprise* : Failing 2 CAPTCHAs in a single session will reveal a special surprise 🎶

## How we built it
- `Stable Diffusion` - Captcha Image Dataset generation & Waldo
- `Swift` - MacOS Target device, UI takes over control until user completes captcha.
- `Python (OpenCV)` - Iris / Pupil ; Eye verification captcha
- `Bash` - Netstat (logging of network received / sent) - determines no. of captcha.

# Setup
## Starting Packet Listener & API Service
```bash
sh services/network_capture.sh
python3 services/app.py
```

## Compile and Execute CodCaptcha 
```bash
open -n <path>
```
