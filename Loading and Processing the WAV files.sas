 /* Loading and Processing the WAV files 
    Setup a CAS session and Assign CASLIBS */
cas;
caslib _all_ assign;

 /* Drop the WAV files if the table exists */
proc casutil;
	droptable casdata="wavfiles" incaslib="public" quiet;
run;

 /* Use the loadActionset to load the .wav files in the to_identify.listing file into the wavfiles folder */
proc cas;
	builtins.loadActionSet / actionSet="audio";
	audio.loadAudio / caslib="PUBLIC" casOut={name="wavfiles", caslib="Public"} 

   /* This is in the "PUBLIC" folder at /srv/nfs/kubedata/sse-cas-default-data-pvc-0154628e-fa35-44ac-8c13-3f031bfc78aa/caslibs/public */
		path="to_identify.listing";
run;

 /*
proc cas;
	audio.computeFeatures / mfccOptions={nCeps=12.0} casOut={name="wavfeatures", 
		caslib="Public", promote="TRUE"} table={name="wavfiles", caslib="Public"};
	run;

proc casutil;
	contents casdata='wavfiles' incaslib='public';
run;
*/


  /* Drop the WAV features file if the table exists before recalculating the audio features */
proc casutil;
	droptable casdata="wavfeatures" incaslib="public" quiet;
run;

 /* Extract features from the WAV files */
proc cas;
 audio.computeFeatures /  
        audioColumn="_audio_"
        copyvars={"_path_"}
 /* mfccOptions - this sets the mel-frequency cepstral coefficients (MFCC)  
    nCeps = Integer - specifies the number of cepstral coefficients in each MFCC feature frame (including C0) default=13 - minimum=1*/
        mfccOptions={nCeps=10.0} 
 /* The frequency bins to use for the audio processing are configured using the melBanksOptions parameter and its subparameters. 
    specifies the settings to use to determine the mel-frequency banks. 
    nBins - specifies the number of triangular mel-frequency bins. */
        melBanksOptions={nBins=40.0} 
 /* Specifies the settings to use to determine how to break the audio file into frames. 
    frameShift = specifies the time difference (in milliseconds) between the beginnings of consecutive frames - default is 10
    frameLength = specifies the length of a frame (in milliseconds) - default is 25
    dither = specifies the dithering constant (0.0 means no dithering) */
        frameExtractionOptions={"frameShift"=10, "frameLength"=25, "dither"=0.0}
 /* Just input and output tables */
        casOut={name="wavfeatures", caslib="Public", promote="TRUE"} 
        table={name="wavfiles", caslib="Public"}
 /* Modifies the output by setting the number of frames in the output table to the specified number. 
    If this parameter is not specified, the number of frames in the output table is set to the maximum number of output frames 
    that are produced among all audio data files in the input table. 
    Audio data files that produce fewer output frames than the value of this parameter will have zero-padded frames appended at the end, 
    whereas audio data files that produce more frames than the value of this parameter simply have their extra frames dropped.
 */
        nOutputFrames=10
  /* featureScalingMethod - specifies the feature scaling method to apply to the computed feature vectors.
     STANDARDIZATION - specifies that the set containing the same coefficient across all frames in an audio file should be scaled 
     so that the resulting set has a mean of zero and unit variance. */
        featureScalingMethod="STANDARDIZATION"
  ;
run;

proc casutil;
	contents casdata='wavfeatures' incaslib='public';
run;

 /* With mfccOptions - nceps=40 - get 402 columns - on shortest wav file 
    With mfccOptions - nceps=30 - get 302 columns - on shortest wav file
    With mfccOptions - nceps=1 - get 12 columns - on shortest wav file
    With mfccOptions - nceps=1 and nOutputFrames=100 - get 102 columns - on shortest wav file
    With mfccOptions - nceps=2 and nOutputFrames=100 - get 202 columns - on shortest wav file
    With mfccOptions - nceps=10 and nOutputFrames=10 - get 102 columns - on shortest wav file
 */

