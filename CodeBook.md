run_analysis.R

This is a markdown file which acts as the code book for the run_analysis.R script from cdnellery.

Within the project we had to define names for two sets of identifiers.

ACTIVITY LABELS
- I decided to reutilise the labels as provided within the data pack provided. I deemed these descriptive enough for the purpose of this investigation.
	1	WALKING
	2	WALKING_UPSTAIRS
	3	WALKING_DOWNSTAIRS
	4	SITTING
	5	STANDING
	6	LAYING

FEATURE NAMES
- There were several aspects of the feature names which I modified in order to clarify the features in the final dataset. The structure remained largely unchanged, however certain features were modified for better readability. The guiding principle was that someone coming new to the experiment would be able to understand what each referred to. The changes I made were;
	Old Feature Name	Replacement		Why
	t			Time			Feature names previously called t as their first character, however this refers to time based observations.
	f			Fourier			Feature names previously called f as their first character, however this in fact refers to a Fourier transformation.
	.../..			.			Previous feature names had unused characters in the form of full stops. These were reduced down.
	mean			Mean			Standardised across all, whether at the end or in the middle of the variable name.
	std			StandardDeviation	As one of the key measures, this needed to be clear. Previous naming 'std' was not clear.
	