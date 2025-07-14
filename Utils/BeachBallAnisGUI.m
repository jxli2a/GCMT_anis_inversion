function BeachBallAnisGUI
%% Plot the beach ball in TTI anisotropic medium
%  By Jiaxuan Li        2017-10-18
% close all;
figdata.fig = figure('Toolbar','figure','Unit','Normalized','Position',[0.2,0.2,0.6,0.6]);
set(figdata.fig,'name','Beach Ball in TTI Medium','NumberTitle','off');
set(figdata.fig,'Defaultuicontrolunits','Normalized')
set(figdata.fig,'Defaultaxesunits','Normalized')
set(figdata.fig,'Defaultuipanelunits','Normalized')
figdata.hax = axes('Position',[0.25,0.17,0.65,0.65]); axis off;
figdata.const.d2r = pi/180;
figdata.tti.thomsen = zeros(1,3);
figdata.tti.angle = zeros(1,2);
figdata.tti.cijkl = [100,100,40,50,50];
figdata.tti.Ct = get_Ct(figdata.tti.cijkl(2), figdata.tti.cijkl(3), figdata.tti.thomsen, figdata.tti.angle);
figdata.tti.Ciso = get_Ct(figdata.tti.cijkl(2),figdata.tti.cijkl(3),[0,0,0],[0,0]);
figdata.tti.Bt = get_Bt(figdata.tti.cijkl(2),figdata.tti.cijkl(3),figdata.tti.thomsen,figdata.tti.angle);
figdata.tti.Biso = get_Bt(figdata.tti.cijkl(2),figdata.tti.cijkl(3),[0,0,0],[0,0]);
figdata.fault.plane1 = zeros(1,3);
figdata.fault.plane2 = zeros(1,3);
figdata.fault.d = get_fault_geometry(0,0,0);
figdata.mt.mt = zeros(1,6);
figdata.mt.mtiso = zeros(1,6); % mt in isotropic medium
figdata.mt.fclvd = 0;
figdata.mt.iso  = 0;
figdata.mt.type = 'devi';
% Anisotropy Model Panel
ttipanel = uipanel('parent',figdata.fig,'title','tti model','Unit','Normalized','Position',[0.05,0.5,0.2,0.45]);
ny = 7; ratio = 2;
ymarg = 1/(ny+1+ratio*ny); yheig = ymarg*ratio;
Y = (0:ny-1)*(ymarg+yheig)+ymarg;
uicontrol(ttipanel,'Style','text','String','C33',  'Position',[0.05,Y(7),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.cijkl(2)),'Position',[0.5,Y(7),0.4,yheig],'callback',{@Plot_callback_tti,'c33'});
uicontrol(ttipanel,'Style','text','String','C44',  'Position',[0.05,Y(6),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.cijkl(3)),'Position',[0.5,Y(6),0.4,yheig],'callback',{@Plot_callback_tti,'c44'});
uicontrol(ttipanel,'Style','text','String','theta','Position',[0.05,Y(5),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.angle(1)),'Position',[0.5,Y(5),0.4,yheig],'callback',{@Plot_callback_tti,'theta'});
uicontrol(ttipanel,'Style','text','String','phi',  'Position',[0.05,Y(4),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.angle(2)),'Position',[0.5,Y(4),0.4,yheig],'callback',{@Plot_callback_tti,'phi'});
uicontrol(ttipanel,'Style','text','String','eps',  'Position',[0.05,Y(3),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.thomsen(1)),'Position',[0.5,Y(3),0.4,yheig],'callback',{@Plot_callback_tti,'eps'});
uicontrol(ttipanel,'Style','text','String','gamma','Position',[0.05,Y(2),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.thomsen(2)),'Position',[0.5,Y(2),0.4,yheig],'callback',{@Plot_callback_tti,'gamma'});
uicontrol(ttipanel,'Style','text','String','delta','Position',[0.05,Y(1),0.4,yheig]);
uicontrol(ttipanel,'Style','edit','String',num2str(figdata.tti.thomsen(3)),'Position',[0.5,Y(1),0.4,yheig],'callback',{@Plot_callback_tti,'delta'});
% Fault Geometry Panel
faultpanel = uipanel('parent',figdata.fig,'title','fault','Unit','Normalized','Position',[0.05,0.05,0.2,0.45]);
ny = 3; ratio = 2;
ymarg = 1/(ny+1+2*ratio*ny); yheig = ymarg*ratio;
Y1 = (0:ny-1)*(ymarg+2*yheig)+ymarg;
Y2 = Y1+yheig;
uicontrol(faultpanel,'Style','text','String','Strike =  ','HorizontalAlignment','left','Position',[0.05,Y2(3),0.3,yheig]);
figdata.hedit.strike   = uicontrol(faultpanel,'Style','edit','String',num2str(figdata.fault.plane1(1)),'HorizontalAlignment','center','Position',[0.3,Y2(3)+yheig*0.15,0.3,yheig],'callback',{@Plot_callback_fault_edit,'strike'});
figdata.hslider.strike = uicontrol(faultpanel,'Style','slider','Min',0,   'Max',360,'Value',figdata.fault.plane1(1),'SliderStep',[1/360 1],'Position',[0.05,Y1(3),0.95,yheig],'callback',{@Plot_callback_fault_slider,'strike'});
uicontrol(faultpanel,'Style','text','String','Dip    =  ','HorizontalAlignment','left','Position',[0.05,Y2(2),0.3,yheig]);
figdata.hedit.dip      = uicontrol(faultpanel,'Style','edit','String',num2str(figdata.fault.plane1(2)),'HorizontalAlignment','center','Position',[0.3,Y2(2)+yheig*0.15,0.3,yheig],'callback',{@Plot_callback_fault_edit,'dip'});
figdata.hslider.dip    = uicontrol(faultpanel,'Style','slider','Min',0,   'Max',90, 'Value',figdata.fault.plane1(2),'SliderStep',[1/90  1],'Position',[0.05,Y1(2),0.95,yheig],'callback',{@Plot_callback_fault_slider,'dip'});
uicontrol(faultpanel,'Style','text','String','Rake   =  ','HorizontalAlignment','left','Position',[0.05,Y2(1),0.3,yheig]);
figdata.hedit.rake     = uicontrol(faultpanel,'Style','edit','String',num2str(figdata.fault.plane1(3)),'HorizontalAlignment','center','Position',[0.3,Y2(1)+yheig*0.15,0.3,yheig],'callback',{@Plot_callback_fault_edit,'rake'});
figdata.hslider.rake   = uicontrol(faultpanel,'Style','slider','Min',-180,'Max',180,'Value',figdata.fault.plane1(3),'SliderStep',[1/360 1],'Position',[0.05,Y1(1),0.95,yheig],'callback',{@Plot_callback_fault_slider,'rake'});
% parameters for moment tensor
figdata.htext.fclvd    = uicontrol('Style','text','String',['fclvd = ',num2str(figdata.mt.fclvd),'; ','iso = ',num2str(figdata.mt.iso)],'Position',[0.50 0.900 0.1500 0.0500]);
% show full moment tensor or show deviatoric part
bgmt = uibuttongroup('Visible', 'on', 'Position', [0.85, 0.90, 0.12, 0.05], 'SelectionChangedFcn', @Bgmt_Selection);
figdata.hbg.full = uicontrol(bgmt, 'Style', 'radiobutton', 'String', 'devi', 'Position', [0, 0, 0.5, 1]);
figdata.hbg.devi = uicontrol(bgmt, 'Style', 'radiobutton', 'String', 'full', 'Position', [0.5, 0, 0.5, 1]);
%figdata.hpopmenu.fullordev = uicontrol('Style', 'popupmenu', 'String',{'full','deviatoric'})
% 3d radiation pattern
figdata.hbutton.rp3d   = uicontrol('Style','pushbutton','String','radiation pattern 3d','Position',[0.85,0.85,0.12,0.05],'callback',{@Plot_Callback_radiation_pattern_3d});
    % update beach ball plot with tti
    function Plot_callback_tti(h,varargin)
        opt = varargin{2};
        var = str2double(get(h,'String'));
        switch opt
            case 'c33'
                figdata.tti.cijkl(2) = var;
            case 'c44'
                figdata.tti.cijkl(3) = var;
            case 'theta'
                figdata.tti.angle(1) = var;
            case 'phi'
                figdata.tti.angle(2) = var;
            case 'eps'
                figdata.tti.thomsen(1) = var;
            case 'gamma'
                figdata.tti.thomsen(2) = var;
            case 'delta'
                figdata.tti.thomsen(3) = var;
        end
        update_beachball_plot('tti');
    end
    % update beach ball plot with fault (slider)
    function Plot_callback_fault_slider(h,varargin)
        opt = varargin{2};
        var = round(get(h,'Value'));
        set(h,'Value',var);
        switch opt
            case 'strike'
                figdata.fault.plane1(1) = var;
                set(figdata.hedit.strike,'String',num2str(var))
            case 'dip'
                figdata.fault.plane1(2) = var;
                set(figdata.hedit.dip,   'String',num2str(var))
            case 'rake'
                figdata.fault.plane1(3) = var;
                set(figdata.hedit.rake,  'String',num2str(var))
        end
        update_beachball_plot('fault');
    end
    % update beach ball plot with fault (edit)
    function Plot_callback_fault_edit(h,varargin)
        opt = varargin{2};
        var = str2double(get(h,'String'));
        set(h,'Value',var);
        switch opt
            case 'strike'
                figdata.fault.plane1(1) = var;
                set(figdata.hslider.strike,'Value',var)
            case 'dip'
                figdata.fault.plane1(2) = var;
                set(figdata.hslider.dip,   'Value',var)
            case 'rake'
                figdata.fault.plane1(3) = var;
                set(figdata.hslider.rake,  'Value',var)
        end
        update_beachball_plot('fault');
    end
    function Plot_Callback_radiation_pattern_3d(h,varargin)
        %plot_radiation_pattern_3d(figdata.mt.mt); % cannot show abs value by pattern, sign by color
        plot_radpat_3d(figdata.mt.mt)
    end
    % Update Beach Ball Callback function
    function update_beachball_plot(opt)
        d2r     = figdata.const.d2r;
        strike1 = figdata.fault.plane1(1);
        dip1    = figdata.fault.plane1(2);
        theta = figdata.tti.angle(1)*d2r;
        phi   = figdata.tti.angle(2)*d2r;
        switch opt
            case 'tti'
                c33   = figdata.tti.cijkl(2); c44 = figdata.tti.cijkl(3);
                Ct = get_Ct(c33,c44,figdata.tti.thomsen,figdata.tti.angle);
                Ciso = get_Ct(c33,c44,[0,0,0],[0,0]);
                Bt = C_to_B_s(Ct);
                Biso = C_to_B_s(Ciso);
                figdata.tti.Ct = Ct;
                figdata.tti.Ciso = Ciso;
                figdata.tti.Bt = Bt;
                figdata.tti.Biso = Biso;
                strike2 = figdata.fault.plane2(1);
                dip2    = figdata.fault.plane2(2);
            case 'fault'
                rake1   = figdata.fault.plane1(3);
                [strike2,dip2,rake2] = auxiliaryplane(strike1,dip1,rake1);
                figdata.fault.plane2 = [strike2,dip2,rake2];
                d = get_fault_geometry(strike1,dip1,rake1);
                figdata.fault.d = d;
            case 'chg'
                strike2 = figdata.fault.plane2(1);
                dip2    = figdata.fault.plane2(2);
        end
        d = figdata.fault.d;
        % check whether use full moment tensor or deviatoric part of moment
        % tensor
        switch figdata.mt.type
            case 'full'
                Tensor = figdata.tti.Ct;
                Tensor_iso = figdata.tti.Ciso;
            case 'devi'
                Tensor = figdata.tti.Bt;
                Tensor_iso = figdata.tti.Biso;
        end
        mt = Change_mt_coordinate(Tensor*d',-1);
        mtiso = Change_mt_coordinate(Tensor_iso*d',-1);
        figdata.mt.mt = mt;
        %[figdata.mt.fclvd, figdata.mt.iso] = fun_mt_decomp(mt,'cmt');
        [figdata.mt.iso, figdata.mt.fclvd] = fun_mt_decomp_new(mt);
        set(figdata.htext.fclvd,'String',['fclvd = ',num2str(figdata.mt.fclvd),'; ','iso = ',num2str(figdata.mt.iso)]);
        axes(figdata.hax);cla;
        plot_beach_ball(mt); hold on;
        plot_nodal_line(strike1,dip1,'b-');
        plot_nodal_line(strike2,dip2,'b-');
        plot_symmetryaxis(theta,phi,'Color','r','Marker','p');
        plot_mt_PBT(mt,'cmt');
        plot_mt_PBT(mtiso,'cmt','ko',0);
    end
    % calculate Bt
    function Bt = get_Bt(c33,c44,thomsen,angle)
        Ct = get_Ct(c33,c44,thomsen,angle);
        Bt = C_to_B_s(Ct);
    end
    % calculate Ct
    function Ct = get_Ct(c33, c44, thomsen, angle)
        eps = thomsen(1);
        gamma = thomsen(2);
        delta = thomsen(3);
        theta = angle(1)*figdata.const.d2r;
        phi = angle(2)*figdata.const.d2r;
        [c11,c33,c44,c66,c13] = thomsen_to_cijkl(c33,c44,eps,gamma,delta);
        Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta,phi);
    end
    % radio button group selection function
    function Bgmt_Selection(~, evt)
        evt.OldValue.String
        evt.NewValue.String
        switch evt.NewValue.String
            case 'full'
                figdata.mt.type = 'full';
            case 'devi'
                figdata.mt.type = 'devi';
        end
        update_beachball_plot('chg')
    end
end