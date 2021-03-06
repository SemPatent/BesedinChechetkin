﻿--3) Сравнение разности длин векторов с допустимой ошибкой delta
CREATE OR REPLACE  FUNCTION compare_vector ( val_vector double precision[], val_index INTEGER[], delta double precision)
RETURNS INTEGER[] AS
$BODY$
DECLARE
  
  valueVectorIn double precision;
  valueVectorCur double precision;
  tmp text;
  i integer;
  j integer;
  indexCompare integer;
  result INTEGER[];
  id_document BIGINT;
  val_vector_cur text;
  lengthIn double precision;
  lengthCur double precision;
BEGIN

  lengthIn := 0;
  --вычисление длины входного вектора
  FOR i IN 1..array_upper(val_index,1) LOOP
     indexCompare := val_index[i];
     lengthIn := lengthIn + val_vector[indexCompare] * val_vector[indexCompare];
  END LOOP;
  lengthIn := sqrt(lengthIn);
  
  j := 1;
  FOR id_document, val_vector_cur IN SELECT values_​​of_the_vectors.id_document, values_​​of_the_vectors.val_vector FROM values_​​of_the_vectors LOOP -- проход по все таблице
    lengthCur := 0;
val_vector_cur := trim(both '[' from val_vector_cur);
     val_vector_cur := trim(both ']' from val_vector_cur);
    FOR i IN 1..array_upper(val_index, 1) LOOP
     indexCompare := val_index[i];
     valueVectorIn := val_vector[indexCompare];

      tmp := split_part(val_vector_cur, ', ', indexCompare);
   
     valueVectorCur := CAST(tmp as DOUBLE PRECISION);

     lengthCur := lengthCur + valueVectorCur*valueVectorCur;
     
     --RAISE NOTICE 'indexCompare % valueVectorIn % valueVectorCur %', indexCompare, valueVectorIn, valueVectorCur; --отладочная печать
    END LOOP;
    lengthCur := sqrt(lengthCur);
    
    IF abs(lengthCur - lengthIn)<delta THEN
  result[j] := id_document;
  j := j+1;
    END IF;
  END LOOP;
  
  RETURN result; 
END
$BODY$
LANGUAGE plpgsql;