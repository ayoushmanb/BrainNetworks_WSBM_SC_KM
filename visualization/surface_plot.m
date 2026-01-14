addpath('/data/wheelock/data1/people/Ayoushman/BrainNetworks_WSBM_SC_KM/support_functions');

%% load IM file
[~,sortID] = sort(IM.order);

%%

Explore_parcel_levels_HSB(IM.key(sortID,2),IM.cMap,...
    IM.Parcels, max(IM.key(:,2)),"your_file_name");
