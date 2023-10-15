%% Read Signal

% Specify the path to your audio file
audioFile = 'Audio Test.m4a';  % Replace with the path to your audio file

% Read the audio file
[y, Fs] = audioread(audioFile);

%% Data Processing

dft_original = fft(y);

% Create a time vector
t_transpose = (0:length(y)-1) / Fs;
t = transpose(t_transpose);

% Noise Reduction
% Step 2: Apply window
N = length(y);  % Length of your signal

% Create a Hanning window
% hanning_window_transpose = 0.5 * (1 - cos(2 * pi * (0:N-1) / (N-1)));
% hanning_window = transpose(hanning_window_transpose);

% Create a Hamming window
hamming_window_transpose = 0.54 - 0.46 * cos(2 * pi * (0:N-1) / (N - 1));
hamming_window = transpose(hamming_window_transpose);

% Apply the Hanning window to your signal
windowed_signal = y .* hamming_window;

% Step 3: Add some noise for demonstration purposes (you might skip this step)
% noise = 0.1 * randn(size(y));  % Gaussian noise with standard deviation 0.1
% noisy_signal = windowed_signal + noise;

% Step 4: Compute the DFT (frequency domain representation)
dft_result = fft(windowed_signal);

%% Encryption Key

% Define the size of the encryption key
keySize = size(dft_result);

% Initialize the encryption key with zeros
encryption_key = zeros(keySize);

% Define the encryption key values
KeyValue0 = 0.007;  % Cannot be 0
KeyValue1 = 0.94;
KeyValue2 = 1.27;
% KeyValue3 = 0.0025;

% Fill in the encryption key with the increasing values
for i = 1:keySize(1)
    if i == 1
        encryption_key = KeyValue0;
    else
    encryption_key(i, :) = (i - 1) * complex(KeyValue1, KeyValue2);
    % encryption_key(i, 2) = (i - 1) * KeyValue3;
    end
end

% Step 5: Encrypt the data via FFT scrambling
% encryption_key = randn(size(dft_result));  % Random key encryption
% encrypted_dft = conv(dft_result, encryption_key); % Convolution
encrypted_dft = dft_result .* encryption_key;

%% Signal Decryption

% Step 6: Send the encrypted signal (in a real application, you'd transmit it)

ifft_encrypted_signal = ifft(encrypted_dft);

% Step 7: Receiver decrypts the signal via the inverse DFT
% decrypted_signal = ifft(decrypted_dft);   % Random key decryption
% decrypted_dft = deconv(encrypted_dft, encryption_key);    % Convolution
decrypted_dft = encrypted_dft ./ encryption_key;

decrypted_signal = ifft(decrypted_dft);

% decrypted_signal_EQ = decrypted_signal * 2;   % Adjust amplitude of
% decrypted signal to closer resemble the original signal

%% Results

% Plot the original, noisy (or windowed), and decrypted signals
figure;
hold off

% subplot(4, 1, 1);
% plot(y, Fs);
% title('Original Signal');

% Figure 1
% Plot the audio waveform
subplot(4, 1, 1);
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal Waveform');

subplot(4, 1, 2);
plot(t, windowed_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Windowed Signal Waveform');

subplot(4, 1, 3);
plot(t, real(encrypted_dft));
xlabel('Time (s)');
ylabel('Amplitude');
title('Encrypted Signal Waveform');

subplot(4, 1, 4);
plot(t, real(decrypted_signal));  % Take the real part since there might be small imaginary components
xlabel('Time (s)');
ylabel('Amplitude');
title('Decrypted Signal Waveform');

sgtitle('Time Domain Graphs of Given Signals');

% % Set a common xlabel for the entire figure
% xlabel('Time (s)');
% 
% % Adjust subplot spacing
% sgtitle('Common Time Axis');

% Figure 2
% figure;
% hold off
% 
% subplot(2, 1, 1);
% plot(t, real(encrypted_dft));
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Encrypted Signal Waveform');
% 
% subplot(2, 1, 2);
% plot(t, real(ifft_encrypted_signal));
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Encrypted Signal Waveform');

% Figure 3
% Optional: Compute and display the magnitude of the DFT coefficients

figure;
hold off

subplot(4, 1, 1);
plot(abs(fftshift(dft_original)));
title('Original Signal');
xlabel('Frequency [Hz]')
ylabel('Magnitude')

subplot(4, 1, 2);
plot(abs(fftshift(dft_result)));
title('Windowed Signal');
xlabel('Frequency [Hz]')
ylabel('Magnitude')

subplot(4, 1, 3);
plot(abs(fftshift(encrypted_dft)));
title('Encrypted Signal');
xlabel('Frequency [Hz]')
ylabel('Magnitude')

subplot(4, 1, 4);
plot(abs(fftshift(decrypted_dft)));
title('Decrypted Signal');
xlabel('Frequency [Hz]')
ylabel('Magnitude')

sgtitle('Frequency Domain Graphs of Given Signals');

%% Playback Original Signal

% Create an audio player object
player_input = audioplayer(y, Fs);

% Play the audio synchronously (blocking)
disp('Playing Original Audio...');
playblocking(player_input);


%% Playback Encrypted Signal

% Create an audio player object for the encrypted audio
player_encrypted = audioplayer(real(encrypted_dft), Fs);

% Play the encrypted audio and indicate it
disp('Playing Encrypted Audio...');
playblocking(player_encrypted);

% % Create an audio player object for the encrypted audio
% player_ifft_encrypted = audioplayer(real(ifft_encrypted_signal), Fs);

% % Play the encrypted audio and indicate it
% disp('Playing IFFT Encrypted Audio...');
% playblocking(player_ifft_encrypted);

%% Playback Decrypted Signal

% play decrypted signal
player_decrypted = audioplayer(real(decrypted_signal), Fs);
disp('Playing Decrypted Audio...');
playblocking(player_decrypted);

% script is completed
disp('Finished');

%% Notes

% The code currently encrypts/decrypts signal via a randomly generated
% encryption key.
% This changes with every time that the code is run.
% Would not be too practical for data encryption, as this key would have to
% be sent over with the audio file for decryption.
% The better idea would be to have a fixed encryption key between both
% parties beforehand.
% However with this the problem arises that this would vary with the size
% of the audio signal.
% A method is to be determined that algorithmically generates a key based
% on the size of the Audio Signal.
% This could be the solution.
% In the event that the key gets leaked, or if the user just wants to
% change it, this can be communicated to each other.
% A single value would change the entire key completely.
% The key would then be an arithmatic series in a double array that
% increases by a fixed value every step.
% The single fixed value then defines the entire encryption key.

% Data signal is in double due to stereo. If the audio signal were in mono
% it would be a single column array.

% Audio also tapers off at the start/end of the signal. This occurs likely
% due to the Hann Window, but I don't think there can be much done about
% that. The window is necessary for noise reduction.

% Is it really though. I mean removing the window would make the decrypted
% audio 1:1 identical to the original signal. Noise reduction isn't really
% the point of an audio encryption system. Might be better to just remove
% the window.

% For the window though, the Hamming window would be better as it has
% non-zero amplitudes at the sidelobes, meaning the beginning and ending of
% the audio signal can be detected better than the Hanning window, which
% has 0 amplitude at the sidelobes. Maybe there's a better choice of window
% but I doubt that.

% Decrypted signal is definitely quieter than the original signal.
% That would have to be fixed also.
% Fix: adjust voice compression by scaling audio signal by x2 in the
% decrypted signal. x2 chosen because it is observed that amplitude of the
% audio signal is halved in the decrypted signal.