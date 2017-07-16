man3_MANS = man/man3/Judy \
	    man/man3/Judy1 \
	    man/man3/Judy1_funcs \
	    man/man3/JudyL \
	    man/man3/JudyL_funcs \
	    man/man3/JudySL \
	    man/man3/JudySL_funcs \
	    man/man3/JudyHS \
	    man/man3/JudyHS_funcs \
	    man/man3/J1T \
	    man/man3/J1S \
	    man/man3/J1U \
	    man/man3/J1F \
	    man/man3/J1N \
	    man/man3/J1L \
	    man/man3/J1P \
	    man/man3/J1FE \
	    man/man3/J1NE \
	    man/man3/J1LE \
	    man/man3/J1PE \
	    man/man3/J1C \
	    man/man3/J1BC \
	    man/man3/J1FA \
	    man/man3/J1MU \
	    man/man3/Judy1Test \
	    man/man3/Judy1Set \
	    man/man3/Judy1Unset \
	    man/man3/Judy1First \
	    man/man3/Judy1Next \
	    man/man3/Judy1Last \
	    man/man3/Judy1Prev \
	    man/man3/Judy1FirstEmpty \
	    man/man3/Judy1NextEmpty \
	    man/man3/Judy1LastEmpty \
	    man/man3/Judy1PrevEmpty \
	    man/man3/Judy1Count \
	    man/man3/Judy1ByCount \
	    man/man3/Judy1FreeArray \
	    man/man3/Judy1MemUsed \
	    man/man3/JudyL \
	    man/man3/JLG \
	    man/man3/JLI \
	    man/man3/JLD \
	    man/man3/JLF \
	    man/man3/JLN \
	    man/man3/JLL \
	    man/man3/JLP \
	    man/man3/JLFE \
	    man/man3/JLNE \
	    man/man3/JLLE \
	    man/man3/JLPE \
	    man/man3/JLC \
	    man/man3/JLBC \
	    man/man3/JLFA \
	    man/man3/JLMU \
	    man/man3/JudyLGet \
	    man/man3/JudyLIns \
	    man/man3/JudyLDel \
	    man/man3/JudyLFirst \
	    man/man3/JudyLNext \
	    man/man3/JudyLLast \
	    man/man3/JudyLPrev \
	    man/man3/JudyLFirstEmpty \
	    man/man3/JudyLNextEmpty \
	    man/man3/JudyLLastEmpty \
	    man/man3/JudyLPrevEmpty \
	    man/man3/JudyLCount \
	    man/man3/JudyLByCount \
	    man/man3/JudyLFreeArray \
	    man/man3/JudyLMemUsed \
	    man/man3/JSLG \
	    man/man3/JSLI \
	    man/man3/JSLD \
	    man/man3/JSLF \
	    man/man3/JSLN \
	    man/man3/JSLL \
	    man/man3/JSLP \
	    man/man3/JSLFA \
	    man/man3/JudySLGet \
	    man/man3/JudySLIns \
	    man/man3/JudySLDel \
	    man/man3/JudySLFirst \
	    man/man3/JudySLNext \
	    man/man3/JudySLLast \
	    man/man3/JudySLPrev \
	    man/man3/JudySLFreeArray \
	    man/man3/JHSG \
	    man/man3/JHSI \
	    man/man3/JHSD \
	    man/man3/JHSFA \
	    man/man3/JudyHSGet \
	    man/man3/JudyHSIns \
	    man/man3/JudyHSDel \
	    man/man3/JudyHSFreeArray


man/man3/Judy: 
	../tool/jhton ext/Judy_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' >  man/man3/Judy

man/man3/J1T man/man3/J1S man/man3/J1U man/man3/J1F man/man3/J1N man/man3/J1L man/man3/J1P       \
man/man3/J1FE man/man3/J1NE man/man3/J1LE man/man3/J1PE man/man3/J1C man/man3/J1BC man/man3/J1FA \
man/man3/J1MU : man/man3/Judy1

man/man3/Judy1:
	( ../tool/jhton ext/Judy1_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/Judy1 ; \
	  cd man/man3 ; \
	  ln -sf Judy J1T ; \
	  ln -sf Judy J1S ; \
	  ln -sf Judy J1U ; \
	  ln -sf Judy J1F ; \
	  ln -sf Judy J1N ; \
	  ln -sf Judy J1L ; \
	  ln -sf Judy J1P ; \
	  ln -sf Judy J1FE ; \
	  ln -sf Judy J1NE ; \
	  ln -sf Judy J1LE ; \
	  ln -sf Judy J1PE ; \
	  ln -sf Judy J1C ; \
	  ln -sf Judy J1BC ; \
	  ln -sf Judy J1FA ; \
	  ln -sf Judy J1MU ; \
	)

man/man3/Judy1Test man/man3/Judy1Set man/man3/Judy1Unset man/man3/Judy1First man/man3/Judy1Next \
man/man3/Judy1Last man/man3/Judy1Prev man/man3/Judy1FirstEmpty man/man3/Judy1NextEmpty          \
man/man3/Judy1LastEmpty man/man3/Judy1PrevEmpty man/man3/Judy1Count man/man3/Judy1ByCount       \
man/man3/Judy1FreeArray man/man3/Judy1MemUsed : man/man3/Judy1_funcs

man/man3/Judy1_funcs:
	( ../tool/jhton ext/Judy1_funcs_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/Judy1_funcs ; \
	  cd man/man3 ; \
	  ln -sf Judy1_funcs Judy1Test ; \
	  ln -sf Judy1_funcs Judy1Set ; \
	  ln -sf Judy1_funcs Judy1Unset ; \
	  ln -sf Judy1_funcs Judy1First ; \
	  ln -sf Judy1_funcs Judy1Next ; \
	  ln -sf Judy1_funcs Judy1Last ; \
	  ln -sf Judy1_funcs Judy1Prev ; \
	  ln -sf Judy1_funcs Judy1FirstEmpty ; \
	  ln -sf Judy1_funcs Judy1NextEmpty ; \
	  ln -sf Judy1_funcs Judy1LastEmpty ; \
	  ln -sf Judy1_funcs Judy1PrevEmpty ; \
	  ln -sf Judy1_funcs Judy1Count ; \
	  ln -sf Judy1_funcs Judy1ByCount ; \
	  ln -sf Judy1_funcs Judy1FreeArray ; \
	  ln -sf Judy1_funcs Judy1MemUsed ; \
	)

man/man3/JLG man/man3/JLI man/man3/JLD man/man3/JLF man/man3/JLN man/man3/JLL man/man3/JLP       \
man/man3/JLFE man/man3/JLNE man/man3/JLLE man/man3/JLPE man/man3/JLC man/man3/JLBC man/man3/JLFA \
man/man3/JLMU : man/man3/JudyL

man/man3/JudyL:
	( ../tool/jhton ext/JudyL_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudyL ; \
	  cd man/man3 ; \
	  ln -sf JudyL JLG ; \
	  ln -sf JudyL JLI ; \
	  ln -sf JudyL JLD ; \
	  ln -sf JudyL JLF ; \
	  ln -sf JudyL JLN ; \
	  ln -sf JudyL JLL ; \
	  ln -sf JudyL JLP ; \
	  ln -sf JudyL JLFE ; \
	  ln -sf JudyL JLNE ; \
	  ln -sf JudyL JLLE ; \
	  ln -sf JudyL JLPE ; \
	  ln -sf JudyL JLC ; \
	  ln -sf JudyL JLBC ; \
	  ln -sf JudyL JLFA ; \
	  ln -sf JudyL JLMU ; \
	)

man/man3/JudyLGet man/man3/JudyLIns man/man3/JudyLDel man/man3/JudyLFirst man/man3/JudyLNext \
man/man3/JudyLLast man/man3/JudyLPrev man/man3/JudyLFirstEmpty man/man3/JudyLNextEmpty       \
man/man3/JudyLLastEmpty man/man3/JudyLPrevEmpty man/man3/JudyLCount man/man3/JudyLByCount    \
man/man3/JudyLFreeArray man/man3/JudyLMemUsed : man/man3/JudyL_funcs

man/man3/JudyL_funcs:
	( ../tool/jhton ext/JudyL_funcs_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudyL_funcs ; \
	  cd man/man3 ; \
	  ln -sf JudyL_funcs JudyLGet ; \
	  ln -sf JudyL_funcs JudyLIns ; \
	  ln -sf JudyL_funcs JudyLDel ; \
	  ln -sf JudyL_funcs JudyLFirst ; \
	  ln -sf JudyL_funcs JudyLNext ; \
	  ln -sf JudyL_funcs JudyLLast ; \
	  ln -sf JudyL_funcs JudyLPrev ; \
	  ln -sf JudyL_funcs JudyLFirstEmpty ; \
	  ln -sf JudyL_funcs JudyLNextEmpty ; \
	  ln -sf JudyL_funcs JudyLLastEmpty ; \
	  ln -sf JudyL_funcs JudyLPrevEmpty ; \
	  ln -sf JudyL_funcs JudyLCount ; \
	  ln -sf JudyL_funcs JudyLByCount ; \
	  ln -sf JudyL_funcs JudyLFreeArray ; \
	  ln -sf JudyL_funcs JudyLMemUsed ; \
	)

man/man3/JSLG man/man3/JSLI man/man3/JSLD man/man3/JSLF man/man3/JSLN man/man3/JSLL man/man3/JSLP \
man/man3/JSLFA : man/man3/JudySL

man/man3/JudySL:
	( ../tool/jhton ext/JudySL_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudySL ; \
	  cd man/man3 ; \
	  ln -sf JudySL JSLG ; \
	  ln -sf JudySL JSLI ; \
	  ln -sf JudySL JSLD ; \
	  ln -sf JudySL JSLF ; \
	  ln -sf JudySL JSLN ; \
	  ln -sf JudySL JSLL ; \
	  ln -sf JudySL JSLP ; \
	  ln -sf JudySL JSLFA ; \
	)

man/man3/JudySLGet man/man3/JudySLIns man/man3/JudySLDel man/man3/JudySLFirst man/man3/JudySLNext \
man/man3/JudySLLast man/man3/JudySLPrev man/man3/JudySLFreeArray : man/man3/JudySL_funcs

man/man3/JudySL_funcs:
	( ../tool/jhton ext/JudySL_funcs_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudySL_funcs ; \
	  cd man/man3 ; \
	  ln -sf JudySL_funcs JudySLGet ; \
	  ln -sf JudySL_funcs JudySLIns ; \
	  ln -sf JudySL_funcs JudySLDel ; \
	  ln -sf JudySL_funcs JudySLFirst ; \
	  ln -sf JudySL_funcs JudySLNext ; \
	  ln -sf JudySL_funcs JudySLLast ; \
	  ln -sf JudySL_funcs JudySLPrev ; \
	  ln -sf JudySL_funcs JudySLFreeArray ; \
	)

man/man3/JHSG man/man3/JHSI man/man3/JHSD man/man3/JHSFA : man/man3/JudyHS

man/man3/JudyHS:
	( ../tool/jhton ext/JudyHS_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudyHS ; \
	  cd man/man3 ; \
	  ln -sf JudyHS JHSG ; \
	  ln -sf JudyHS JHSI ; \
	  ln -sf JudyHS JHSD ; \
	  ln -sf JudyHS JHSFA ; \
	)

man/man3/JudyHSGet man/man3/JudyHSIns man/man3/JudyHSDel man/man3/JudyHSFreeArray : man/man3/JudyHS_funcs

man/man3/JudyHS_funcs:
	( ../tool/jhton ext/JudyHS_funcs_3.htm | grep -v '^[   ]*$$' | sed -e 's/\.C//' > man/man3/JudyHS_funcs ; \
	  cd man/man3 ; \
	  ln -sf JudyHS_funcs JudyHSGet ; \
	  ln -sf JudyHS_funcs JudyHSIns ; \
	  ln -sf JudyHS_funcs JudyHSDel ; \
	  ln -sf JudyHS_funcs JudyHSFreeArray ; \
	)

CLEANFILES = man/man3/*
