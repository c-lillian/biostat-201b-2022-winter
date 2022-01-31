/* Generate classification table for cutoff probrabilities ranging from 10% to 90%.
ROC results are stored using "outroc". You can see the ROC curve and table
at the end of the output */

proc logistic data = dir.hw2_sas desc;
    title2 "Sensitivity and Specificity at Different Cutoffs";
    model depressed = sex age income health /
    ctable pprob = (.1 to .9 by 0.05) clparm=wald outroc = cuteroc;
run;

/* A summary of the variables outroc generates: we are interested in _SENSIT_
and _1MSPEC_ */

proc contents data = cuteroc position;
    title2 "ROC Curve Variable Summary";
run;

/* We need to "fix" the variable _1MSPEC_ to obtain the specificity (instead of 
1 - specificity, which is used in the ROC curve). */
data cuterroc;
    set cuteroc;
    spec = 1-_1MSPEC_;
    label spec = "Specificity"; /*you need this in order to use the order = in legend statement*/
run;

/*all this makes the graph look nicer with different color lines for sens vs spec*/
symbol1 interpol=join
        value=dot
        color=_style_;
symbol2 interpol=join
        value=C
        font=marker
        color=_style_ ;
legend1 order = ("Sensitivity" "Specificity"); /*labels the lines in a legend*/
axis1 order = 0 to 1 by .1 label = none; /*the yaxis defaults to sensitivity so I just make it blank*/

/* This plots the Sensitivity / Specificity graph needed for Q5 Part E. */
/*you need =1 and =2 in the plot statement in order to make the colors of the lines different*/
proc gplot data = cuterroc;
    title2 'Sens/Spec plot';
    plot _sensit_*_prob_=1 spec*_prob_=2 / vaxis=axis1 cframe=ligr overlay legend=legend1;
run;
quit;