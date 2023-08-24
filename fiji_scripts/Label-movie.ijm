Stack.setXUnit("um");
run("Properties...", "channels=1 slices=399 frames=1 pixel_width=0.107 pixel_height=0.107 voxel_depth=0.107");
run("Scale Bar...", "width=5 height=5 font=16 location=[Lower Left] horizontal bold overlay label");
run("Label...", "format=00:00 starting=0 interval=5 x=5 y=20 font=18 text=min range=1-399 use_text");
run("Label...", "format=Text starting=0 interval=5 x=5 y=38 font=18 text=[+ 6uM tub] range=15-399 use_text");
run("Label...", "format=Text starting=0 interval=5 x=5 y=56 font=18 text=[+ 114nM DCX R76S] range=15-399 use_text");
