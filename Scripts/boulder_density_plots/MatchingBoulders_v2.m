clear all;
close all;

cd '/Users/josephlevy/Dropbox/Mars_Glacier_Boulders/Tebolt_Boulders/Matlab_Code';
folder = dir('/Users/josephlevy/Dropbox/Mars_Glacier_Boulders/Tebolt_Boulders/Matlab_Code');
%folder should have txt files in it labeled LETTER_boulders_#
%and a corresponding txt files labeled LETTER_centerline_#
figure;

for num = 1:length(folder)
    boulder_filename = folder(num).name;
    firstletter = boulder_filename(1);
    if contains(boulder_filename, 'boulder') %make sure you're only reading the boulder files
        glacier_num = char(regexp(boulder_filename,'\d*','Match'));
        centerline_filename = strcat(firstletter, '_centerline_', glacier_num, '.txt'); %get the corresponding line file
        p = str2num(glacier_num);
        c = ['r','b','m','k','c'];
        
        %read the data
        linedat = readtable(centerline_filename);
        dot = 1:size(linedat,1);
        dotx = linedat.Easting;
        doty = linedat.Northing;
  
        bdata = readtable(boulder_filename);
        width = bdata.Width;
        long = bdata.Easting;
        lat = bdata.Northing;
        
        bigdat = [];
        
        %This loop finds the closest centerline point to each valid boulder
        for i = 1:length(width)
            if width(i) >= 1 %only take boulders 1m or larger
                dist = sqrt(abs((long(i)-dotx(1))^2+(lat(i)-doty(1))^2));
                for n = 1:length(dot)
                    adist = sqrt(abs(long(i)-dotx(n))^2+(lat(i)-doty(n))^2);
                    if adist<dist
                        dist = adist;
                        closedot = dot(n);
                        closedist = adist;
                    end
                end
                if dist<60 %only include data that makes sense (within buffer)
                    bigdat = [bigdat;width(i),closedot, closedist];
                end
            end
        end
        x = bigdat(:,2);
        y = bigdat(:,1);
        y2 = bigdat(:,3);
        
        
        
        %let's find out where the clumps are
        found_clump = [];
        total_boulders = length(bigdat);
        
        binsz = round(.036*max(x));
        boulder_lim = round(.035*total_boulders);
        
        for step = 1:max(x)
            nums2check = step-round(binsz/2):step+round(binsz/2);
            found_boulders = bigdat((ismember(bigdat(:,2),nums2check)),2);
            if length(found_boulders) > boulder_lim
                found_clump = [found_clump, 1];
            else
                found_clump = [found_clump, 0];
            end
        end
        
        
%         %NOT Normalized Length
%         %plot boulder distance from centerline down-glacier
%         xlabel('Distance Down Glacier (m)');
%         ylabel('Distance From Centerline (m)');
%         title([firstletter,'_',glacier_num, ' Boulder Distribution']);
%         grid on;
%         grid minor;
%         scatter(x,y2,40,'MarkerEdgeColor',[0 .1 .3],...
%             'MarkerFaceColor',c(p),...
%             'LineWidth',1.5)
% %         scatter(x,y2,40,'MarkerEdgeColor',[0 .1 .3],...
% %             'MarkerFaceColor',[0 .7 .7],...
% %             'LineWidth',1.5)
%         %xlabel('Distance Down Glacier (m)');
%         %title([firstletter,'_',glacier_num, ' Defined Pulses']);
        
      % alpha(b, .4)
        


        %Normalized length
        %plot boulder distance from centerline down-glacier
        figure;
        hold on;
        xlabel('Normalized Distance Down Glacier');
        ylabel('Distance From Centerline (m)');
        title([firstletter,'_',glacier_num, ' Boulder Distribution']);
        grid on;
        grid minor;
        scatter((x)./max(x),y2,40,'MarkerEdgeColor',[0 .1 .3],...
            'MarkerFaceColor',c(p),...
            'LineWidth',1.5);
        %this next part draws on the "clump bars"
%         b = area((1:max(x))./max(x),found_clump*60, 'FaceColor',c(p));
%                        scatter(lat,long,40,'MarkerEdgeColor',[0 .1 .3],...
%             'MarkerFaceColor',c(p),...
%             'LineWidth',1.5)
%          alpha(b, .4)
        xlim([0 1]);
        ylim([0 60]);

        
    end
end





   
