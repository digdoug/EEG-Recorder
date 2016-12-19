# EEG Recorder

I wrote this while at MGH in the summer of 2015. 

It's an iOS app for a wearable EEG. The wearable is used for monitoring epileptic seizures, which also gives real-time feedback.

I used the Core Bluetooth package in iOS, which hooks up to a TI CC2540 Bluetooth MCU. 

This particular MCU was advertising at 256 Hz. With a low-pass filter at 125 Hz.

