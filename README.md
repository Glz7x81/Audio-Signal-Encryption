# Audio-Signal-Encryption
Matlab Code for Encrypting/Decrypting an Audio Signal with FFT

The following code encrypts any given audio signal by converting it into the frequency-domain via a Discrete Fourier Transform. A window function is applied to denoise the data, though this step is optional. The resulting signal is scrambled by an encryption key that is generated with 3 key values to create a unique key. Once the signal is scrambled it can be sent to a receiver as an encrypted audio signal.

To decrypt the signal, the inverse operation is executed on the encrypted signal with the encryption key, which reveals the original frequency-domain signal. The Inverse DFT can be done on this signal to yield the original signal.

The signal can only be encrypted/decrypted if both sender and receiver are in agreement upon the 3 key values that define the encryption key.
