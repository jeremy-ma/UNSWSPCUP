function m = reshape_vec(v, seg_size, overlap)

inc = seg_size-overlap; %increment size of capture window
seg_num = floor((length(v)-overlap)/inc);
m = zeros(seg_num,seg_size);

for i=0:seg_num-1
    m(i+1,:) = v(i*inc+1 : i*inc+seg_size);
end    

end