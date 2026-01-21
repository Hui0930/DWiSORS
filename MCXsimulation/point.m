

layer = 1:1:10;

for i = 1 : length(layer)
    cfg.seed = hex2dec('623F9A9E');
    cfg.nphoton =1e8;
    cfg.vol=ones(200,200,200+2*layer(i));
    cfg.vol(:, :, (2*layer(i)+1):(200+2*layer(i))) = 2;
    cfg.vol = uint8(cfg.vol);
    cfg.issrcfrom0=1;
    cfg.unitinmm = 0.5;
    cfg.srctype = 'disk';
    cfg.srcpos = [100, 100, 0];
    cfg.srcdir = [0 0 1];
    cfg.srcparam1 = [1 0 0 0];
    cfg.srcparam2 = [0 0 0 0];
    cfg.prop = [0 0 1 1;           % medium 0: the environment
                0.01654 7.4721 0.9 1.34;   %900nm 960cm-1
                0.00425 91.1 0.9 1.41];
    cfg.tstart = 0;

    cfg.tend = 5e-9;
    cfg.tstep = 5e-9;
    cfg.autopilot = 1;
    cfg.gpuid = 1;
    cfg.isreflect = 1;
    cfg.isrefint = 1;
    flux1 = mcxlab(cfg);

    cfg2 = cfg;
    cfg2.prop = [0 0 1 1;           % medium 0: the environment
                 0.0114 8.209 0.9 1.34;   %880nm  688cm-1
                 0.00448 92.9 0.9 1.41];
    flux2 = mcxlab(cfg2);

    str1='emission1fluxlayer'+string(layer(i));
    str2='emission2fluxlayer'+string(layer(i));
    str3='emissioncfg1layer'+string(layer(i));
    str4='emissioncfg2layer'+string(layer(i));

    save(str1,'flux1')
    save(str2,'flux2')
    save(str3,'cfg')
    save(str4,'cfg2')
end
