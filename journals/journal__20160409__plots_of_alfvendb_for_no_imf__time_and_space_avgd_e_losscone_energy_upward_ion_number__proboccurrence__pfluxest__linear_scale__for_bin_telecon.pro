;2016/04/01 These plots are on the same scale and have the same binning as those I'll be showing Bin and Bill next Monday
PRO JOURNAL__20160409__PLOTS_OF_ALFVENDB_FOR_NO_IMF__TIME_AND_SPACE_AVGD_E_LOSSCONE_ENERGY_UPWARD_ION_NUMBER__PROBOCCURRENCE__PFLUXEST__LINEAR_SCALE__FOR_BIN_TELECON

  nonstorm                       = 0
  altitudeRange                  = [0000,4175]
  
  ;; plotSuff                       = 'high-energy_e'

  tile_images                    = 1
  tiling_order                   = [3,0,2,1]

  divide_by_width_x              = 1 ;for ion plot and eflux plot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  do_timeAvg                     = 1
  probOccurrencePlot             = 1
  logAvgPlot                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 61
  ;; maxILAT                        = 86

  hemi                           = 'SOUTH'
  minILAT                        = -86
  maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 5.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 5

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  probOccurrenceRange            = [0,0.15]
  logProbOccurrence              = 0

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  pPlotRange                     = [0,1] ;for time-averaged
  logPFPlot                      = 0

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; logENumFlPlot                 = 1
  eNumFlRange                   = [0,1] ;for time-, space-averaged
  logENumFlPlot                 = 0
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  ;; iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
  ;; logIFPlot                      = 1
  iPlotRange                     = [0,1e8] ;for time-averaged plot
  logIFPlot                      = 0

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
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
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
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     PLOTSUFFIX=plotSuff, $
     TILE_IMAGES=tile_images, $
     N_TILE_ROWS=n_tile_rows, $
     N_TILE_COLUMNS=n_tile_columns, $
     TILEPLOTSUFF=tilePlotSuff, $
     TILING_ORDER=tiling_order, $
     /CB_FORCE_OOBHIGH, $
     ;; /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER
  
END