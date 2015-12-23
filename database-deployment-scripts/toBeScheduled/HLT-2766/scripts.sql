SET @TYPE = 'healthSitu';

UPDATE aggregator.general SET description = 'Compare your options'  WHERE type = @TYPE
   AND code = 'LC' and description = 'Compare my options' and (status IS NULL or status !=0) and orderSeq = 1 limit 1;

UPDATE aggregator.general SET description = 'Replace your current cover'  WHERE type = @TYPE
   AND code = 'LBC' and description = 'Replace my current cover' and (status IS NULL or status !=0) and orderSeq = 2 limit 1;

UPDATE aggregator.general SET description = 'Grow your family'  WHERE type = @TYPE
   AND code = 'CSF' and description = 'Grow my family' and (status IS NULL or status !=0) and orderSeq = 3 limit 1;


-- test expect 3
select count(*) from aggregator.general where type = @TYPE
and description like '%your%'  and (status IS NULL OR status !=0) order by orderseq;

-- test expect 0
select count(*) from aggregator.general where type = @TYPE
and description like '%my%'  and (status IS NULL OR status !=0) order by orderseq;

-- ROLL back
/*
UPDATE aggregator.general SET description = 'Compare my options'  WHERE type = @TYPE
   AND code = 'LC' and description = 'Compare your options' and (status IS NULL or status !=0) and orderSeq = 1 limit 1;

UPDATE aggregator.general SET description = 'Replace my current cover'  WHERE type = @TYPE
   AND code = 'LBC' and description = 'Replace your current cover' and (status IS NULL or status !=0) and orderSeq = 2 limit 1;

UPDATE aggregator.general SET description = 'Grow my family'  WHERE type = @TYPE
   AND code = 'CSF' and description = 'Grow your family' and (status IS NULL or status !=0) and orderSeq = 3 limit 1;

-- test expect 0
select count(*) from aggregator.general where type = @TYPE
and description like '%your%'  and (status IS NULL OR status !=0) order by orderseq;

-- test expect 3
select count(*) from aggregator.general where type = @TYPE
and description like '%my%'  and (status IS NULL OR status !=0) order by orderseq;

 */