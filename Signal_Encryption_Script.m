%% Read File

% Specify the path to your audio file
audioFiletoEncrypt = 'Audio Test.m4a';  % Replace with the path to your audio file

% Read the audio file
[y, Fs] = audioread(audioFiletoEncrypt);

% % Create a time vector
% t_transpose = (0:length(y)-1) / Fs;
% t = transpose(t_transpose);

N = length(y);  % Length of your signal

% % Create a Hamming window
% hamming_window_transpose = 0.54 - 0.46 * cos(2 * pi * (0:N-1) / (N - 1));
% hamming_window = transpose(hamming_window_transpose);

% % Apply the Hanning window to your signal
% windowed_signal = y .* hamming_window;

% Step 4: Compute the DFT (frequency domain representation)
dft_result = fft(y);

%% Encrypt File with Key

% Define the size of the encryption key
keySize = size(dft_result);

% Initialize the encryption key with zeros
encryption_key = zeros(keySize);

% Define the encryption key values
KeyValue0 = 0.000000000019;  % Cannot be 0
KeyValue1 = 0.000000000021;
KeyValue2 = 0.000000000007;

% Fill in the encryption key with the increasing values
for i = 1:keySize(1)
    if i == 1
        encryption_key = KeyValue0;
    else
        encryption_key(i, :) = KeyValue0 + (i - 1) * complex(KeyValue1, KeyValue2);
    end
end

encrypted_dft = dft_result .* encryption_key;

%% Real and Imaginary Parts of FFT (Stereo Sound Channels)

encrypted_dft_stereo = zeros(size(encrypted_dft));

encrypted_dft_stereo(:, 1) = real(encrypted_dft(:, 1));
encrypted_dft_stereo(:, 2) = imag(encrypted_dft(:, 1));

%% Normalize Audio

% % Normalize the decrypted audio data to the valid range (-1 to 1)
% normalized_encrypted_dft = encrypted_dft_stereo / max(abs(encrypted_dft));

%% Save Encrypted File

% Define the directory where you want to save the file
outputDirectory = 'C:\Users\20221247\OneDrive - TU Eindhoven\Documents\TUe\Year 2\Quarter 1\4CB00 (Signals and Systems)\Project';  % Replace with your desired directory path

% Specify the filename for the output audio file
EncryptedFileName = 'Encrypted Audio.m4a';  % Replace with your desired file name

% Use fullfile to create the full path to the output file
EncryptedAudioFile = fullfile(outputDirectory, EncryptedFileName);

% Write the encrypted audio to the output file
audiowrite(EncryptedAudioFile, encrypted_dft_stereo, Fs);

% Display a message indicating the save completion
disp(['Encrypted audio saved as ' EncryptedFileName]);