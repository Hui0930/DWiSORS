

layer = 1:1:10;
radii = 3:2:21;

for i = 1 : length(layer)
    cfg.seed = hex2dec('623F9A9E');
    cfg.nphoton =1e8;
    cfg.vol=ones(200,200,200+2*layer(i));
    cfg.vol(:, :, (2*layer(i)+1):(200+2*layer(i))) = 2;
    cfg.vol = uint8(cfg.vol);
    cfg.issrcfrom0=1;
    cfg.unitinmm = 0.5;
    cfg.srctype = 'ring';
    cfg.srcpos = [100, 100, 0];
    cfg.srcdir = [0 0 1];
    cfg.prop = [0 0 1 1;
                0.0102 9.068 0.9 1.34;
                0.00472 96.3 0.9 1.41];
    for j = 1:length(radii)
        cfg.srcparam1 = [2*radii(j)+1 2*radii(j)-1 0 0];
        cfg.srcparam2 = [0 0 0 0];
        cfg.tstart = 0;

        cfg.tend = 5e-9;
        cfg.tstep = 5e-9;
        cfg.autopilot = 1;
        cfg.gpuid = 1;
        cfg.isreflect = 1;
        cfg.isrefint = 1;
        fluence=mcxlab(cfg);
        
        
        str1='excitationfluxlayer'+string(layer(i))+'sds'+string(radii(j));

        str2='excitationcfglayer'+string(layer(i))+'sds'+string(radii(j));

        
        save(str1,'fluence')
  
        save(str2,'cfg')
 
        
    end
end
