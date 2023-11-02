# OFDM_communication_system
University project - Build a semi-complete communication system based on OFDM

* Implemented basic blocks of OFDM based transmitter and receiver considering channels of AWGN and multipath fading.   
* Generated probability of error (Pe) curves against signal-to-noise ratio (Eb/No) for different modulation schemes (QPSK, 16QAM, 64QAM) and under different MIMO setups (1x1 SISO, 1x2 SIMO).

## OFDM transmitter blocks
1) Channel coding using linear block codes
2) Symbol mapping using QPSK, 16 QAM and 64 QAM (Modulation)
3) IFFT for OFDM based modulation
4) Cyclic prefix insertion

## OFDM receiver blocks
1) Remove Cyclic prefix
2) FFT
3) Symbol mapper (Demodulation)
4) Channel decoding

## Channel models
1) AWGN
2) Multipath fading

## MIMO setups
* 1x1 SISO
* 1x2 SIMO
