;2016/04/23 I've added a bunch of keywords with the specific goal of testing just how on earth they compare to what I've been doing
PRO JOURNAL__20160423__TEST_CHASTON_ET_AL_2007_STYLE_GROSSRATES

  nonstorm                       = 0
  altitudeRange                  = [0000,4175]
  
  ;; plotSuff                       = 'high-energy_e'

  tile_images                    = 0
  ;; tiling_order                   = [3,1,2,0]

  add_variance_plots             = 1
  var__rel_to_mean_variance      = 0
  ;; var__plotRange                 = [0,0.5]

  divide_by_width_x              = 0 ;for ion plot and eflux plot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  do_timeAvg                     = 0
  do_grossRate_fluxQuantities    = 0
  do_grossRate_with_long_width   = 1
  div_fluxPlots_by_applicable_orbs = 1
  probOccurrencePlot             = 1

  logAvgPlot                     = 0

  autoscale_fluxPlots            = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 2.0
  ;; shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  pPlotRange                     = [1e6,1e8] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; logENumFlPlot                 = 1
  eNumFlRange                   = [1e6,1e8] ;for time-, space-averaged
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  ;; iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
  ;; logIFPlot                      = 1
  iPlotRange                     = [1e20,1e23] ;for time-averaged plot
  logIFPlot                      = 1

  PLOT_ALFVEN_STATS_IMF_SCREENING, $
     ALTITUDERANGE=altitudeRange, $
     NONSTORM=nonstorm, $
     CHARERANGE=charERange, $
     MASKMIN=maskMin, $
     HEMI=hemi, $
     BINMLT=binMLT, $
     SHIFTMLT=shiftMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     /MIDNIGHT, $
     DO_DESPUNDB=do_despun, $
     /DO_NOT_CONSIDER_IMF, $
     SMOOTHWINDOW=smoothWindow, $
     LOGAVGPLOT=logAvgPlot, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     ADD_VARIANCE_PLOTS=add_variance_plots, $
     VAR__PLOTRANGE=var__plotRange, $
     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
     DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
     /PPLOTS, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     /ENUMFLPLOTS, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     ENUMFLPLOTRANGE=eNumFlRange, $
     LOGENUMFLPLOT=logENumFlPlot, $
     NONEGENUMFL=noNegENumFl, $
     /IONPLOTS, $
     IFLUXPLOTTYPE=iFluxPlotType, $
     /NONEGIFLUX, $
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     PLOTSUFFIX=plotSuff, $
     TILE_IMAGES=tile_images, $
     N_TILE_ROWS=n_tile_rows, $
     N_TILE_COLUMNS=n_tile_columns, $
     TILEPLOTSUFF=tilePlotSuff, $
     TILING_ORDER=tiling_order, $
     ;; /CB_FORCE_OOBHIGH, $
     ;; /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER



END