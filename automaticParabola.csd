<CsoundSynthesizer>
<CsOptions>
	-o automaticParabola.wav
</CsOptions>

<CsInstruments>
	sr = 44100
	ksmps = 100
	nchnls = 2
	0dbfs = 1000000000

	#define USE_SPATIALIZATION ##
	#include "Spatialize.inc"

	gk_BformatDecoder_SpeakerRig init 1
	gk_Spatialize_SpeakerRigRadius init 5.0
	gk_SpatialReverb_ReverbDecay init 0.96
	gk_SpatialReverb_CutoffHz init sr
	gk_SpatialReverb_RandomDelayModulation init 4.0
	gk_LocalReverbByDistance_Wet init 0.5
	; This is a fraction of the speaker rig radius.
	gk_LocalReverbByDistance_FrontWall init 0.9
	gk_LocalReverbByDistance_ReverbDecay init 0.6
	gk_LocalReverbByDistance_CutoffHz init 20000
	gk_LocalReverbByDistance_RandomDelayModulation init 1.0

	connect "FluteA", "outbformat", "BformatDecoder", "inbformat"
	connect"FluteA", "out", "SpatialReverb", "in"

	connect "SpatialReverb", "outbformat", "BformatDecoder", "inbformat"

	alwayson "SpatialReverb"
	alwayson "BformatDecoder"
	alwayson "Controls"

	instr GaussNoise
		irange   = p4
		imu      = p5
		isamples = p6
		indx     = 0
		icount   = 1
		ix       = 0.0
		ix2      = 0.0
		loop:
		i1       gauss   irange
		i1       =       i1 + imu
		ix       =       ix + i1
		ix2      =       ix2 + i1*i1
		if i1 >= -(irange+imu) && i1 <= (irange+imu) then
		  icount = icount+1
		endif
		loop_lt indx, 1, isamples, loop
		imean    =       ix / isamples
		istd     =       sqrt(ix2/isamples - imean*imean)
	endin


	instr FluteA
		asig diskin2 p4
		asig = asig ;* 10

		insno = p1
		istart = p2
		iduration = p3
		ivelocity = 1
		iphase = 1
		ipan = 1
		kx = p5
		ky = p6
		kz = p7

		absignal[] init 16
		absignal, asend Spatialize asig, kx, ky, kz
		outletv "outbformat", absignal
		kelapsed timeinsts
	endin

	instr Controls
		gk_LocalReverbByDistance_Wet invalue
		   "gk_LocalReverbByDistance_Wet"
		gk_LocalReverbByDistance_ReverbDecay invalue
		   "gk_LocalReverbByDistance_ReverbDecay"
		gk_LocalReverbByDistance_CutoffHz invalue
		   "gk_LocalReverbByDistance_CutoffHz"
		gk_SpatialReverb_CutoffHz invalue
		   "gk_SpatialReverb_CutoffHz"
		gk_SpatialReverb_Gain invalue
		   "gk_SpatialReverb_Gain"
		gk_BformatDecoder_MasterLevel invalue
		   "gk_BformatDecoder_MasterLevel"
	endin
</CsInstruments>
<CsScore>
	#define A #"a440_kh_2019092213_normalized.wav"#
	t 0 60

	i"FluteA" 14.0     10 $A 0.0 0.0 -4.0
	i"FluteA" 15.333     10 $A 30.0 0.0 -7.75
	i"FluteA" 16.667     10 $A 60.0 0.0 -19.0
	i"FluteA" 18.0     10 $A 0.0 0.0 -4.0
	i"FluteA" 19.333     10 $A -30.0 0.0 -7.75
	i"FluteA" 20.667     10 $A -60.0 0.0 -19.0
	i"FluteA" 22.0     10 $A 0.0 0.0 -4.0
	i"FluteA" 23.333     10 $A 0.0 30.0 -7.75
	i"FluteA" 24.667     10 $A 0.0 60.0 -19.0
	i"FluteA" 26.0     10 $A 0.0 0.0 -4.0
	i"FluteA" 27.333     10 $A -0.0 -30.0 -7.75
	e 34

</CsScore>
</CsoundSynthesizer>
