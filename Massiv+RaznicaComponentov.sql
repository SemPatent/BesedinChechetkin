CREATE OR REPLACE  FUNCTION compare_vector ( val_vector double precision[], val_index INTEGER[], delta double precision)
RETURNS INTEGER[] AS
$BODY$
DECLARE
  valueVectorIn double precision;
  valueVectorCur double precision;
  i integer;
  j integer;
  indexCompare integer;
  result INTEGER[];
  id_document BIGINT;
  val_vector_cur double precision[];
  isEqual integer;
BEGIN

  j := 1;
  FOR id_document, val_vector_cur IN SELECT values_​​of_the_vectors.id_document, values_​​of_the_vectors.val_vector FROM values_​​of_the_vectors LOOP -- проход по все таблице
    isEqual := 1;
    FOR i IN 1..array_upper(val_index, 1) LOOP
     indexCompare := val_index[i];
     valueVectorIn := val_vector[indexCompare];
     valueVectorCur := val_vector_cur[indexCompare];
      
     IF abs(valueVectorIn - valueVectorCur)>delta THEN
  isEqual := 0;
     END IF;

    END LOOP;
    IF isEqual = 1 THEN
  result[j] := id_document;
  j := j+1;
    END IF;
  END LOOP;
  
  RETURN result; 
END
$BODY$
LANGUAGE plpgsql;	