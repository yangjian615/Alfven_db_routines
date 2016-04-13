;;2015/10/14
;2015/12/25 Added force_oobHigh and force_oobLow keywords
FUNCTION MAKE_H2DSTR_TMPLT,MIN1=min1in,MIN2=min2in, $
                           MAX1=max1in,MAX2=max2in, $
                           BIN1=b1in,BIN2=b2in, $
                           SHIFT1=s1in,SHIFT2=s2in, $
                           DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                           DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i, $
                           ;; PLOT_I=plot_i, $
                           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                           CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                           CB_FORCE_OOBLOW=cb_force_oobLow

    ;Supply default values for keywords.
    min1 = (N_ELEMENTS(min1in) gt 0) ? min1in : (0 < im1min)
    max1 = (N_ELEMENTS(max1in) gt 0) ? max1in : im1max
    min2 = (N_ELEMENTS(min2in) gt 0) ? min2in : (0 < im2min)
    max2 = (N_ELEMENTS(max2in) gt 0) ? max2in : im2max
    b1 = (N_ELEMENTS(b1in) gt 0) ? b1in : 1L
    b2 = (N_ELEMENTS(b2in) gt 0) ? b2in : 1L
    s1 = (N_ELEMENTS(s1in) GT 0) ? s1in : 0
    s2 = (N_ELEMENTS(s2in) GT 0) ? s2in : 0

    ;Get # of bins for each
    im1bins = FLOOR((max1-min1) / b1) + 1L
    im2bins = FLOOR((max2-min2) / b2) + 1L

    if (im1bins le 0) then MESSAGE, 'Illegal bin size for V1.'
    if (im2bins le 0) then MESSAGE, 'Illegal bin size for V2.'


    h2dStr_tmplt={tmplt_h2dStr, $
                  data            : KEYWORD_SET(do_plot_i) ? LIST() : DBLARR(im1bins,im2bins), $
                  title           : "Template for 2D hist structure", $
                  lim             : DBLARR(2), $
                  shift1          : s1, $
                  shift2          : s2, $
                  is_logged       : 0, $
                  avgType         : '', $
                  is_fluxdata     : 0, $
                  labelFormat     : '', $
                  do_midCBLabel   : 0, $
                  logLabels       : 0, $
                  do_posNeg_cb    : 0, $
                  do_plotIntegral : 0, $
                  do_timeAvg      : KEYWORD_SET(do_timeAvg_fluxQuantities), $
                  do_grossRate    : KEYWORD_SET(do_grossRate_fluxQuantities), $
                  force_oobHigh   : KEYWORD_SET(cb_force_oobHigh), $
                  force_oobLow    : KEYWORD_SET(cb_force_oobLow), $
                  dont_mask_me    : 0}

    RETURN,h2dStr_tmplt

END