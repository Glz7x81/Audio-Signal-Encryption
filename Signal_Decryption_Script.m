%% Read File

% Specify the path to your audio file
audioFiletoDecrypt = 'Encrypted Audio.m4a';  % Replace with the path to your audio file

% Read the audio file
[y, Fs] = audioread(audioFiletoDecrypt);

%% Reformat Audio Data to usable Form

y_stereo = zeros(size(y));

for i = 1:size(y)  
    y_stereo(i, 1) = y(i, 1) + y(i, 2);
end

y_stereo(:, 2) = y_stereo(:, 1);

%% Decrypt File with Key

% Define the size of the encryption key
keySize = size(y_stereo);

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

decrypted_dft = y_stereo ./ encryption_key;

decrypted_signal = ifft(decrypted_dft);

%% Normalize Audio

% Normalize the decrypted audio data to the valid range (-1 to 1)
normalized_decrypted_signal = decrypted_signal / max(abs(decrypted_signal));

%% Save Decrypted File

% Define the directory where you want to save the file
outputDirectory = 'C:\Users\20221247\OneDrive - TU Eindhoven\Documents\TUe\Year 2\Quarter 1\4CB00 (Signals and Systems)\Project';  % Replace with your desired directory path

% Specify the filename for the output audio file
DecryptedFileName = 'Decrypted Audio.m4a';  % Replace with your desired file name

% Use fullfile to create the full path to the output file
DecryptedAudioFile = fullfile(outputDirectory, DecryptedFileName);

% Write the encrypted audio to the output file
audiowrite(DecryptedAudioFile, real(normalized_decrypted_signal), Fs);

% Display a message indicating the save completion
disp(['Decrypted audio saved as ' DecryptedFileName]);