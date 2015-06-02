

--4) Сравнение отклонения косинуса угла между векторами от единицы с допустимой ошибкой delta
CREATE OR REPLACE  FUNCTION compare_vector (val_vector double precision[], val_index INTEGER[], delta double precision)
RETURNS INTEGER[] AS
$BODY$
DECLARE
  colname text;
  valueVectorIn double precision;
  valueVectorCur double precision;
  i integer;
  j integer;
  indexCompare integer;
  result INTEGER[];
  id_doc BIGINT;
  val_vector_cur double precision[];
  cos double precision;
  part_of_the_denominatorIn double precision;
  part_of_the_denominatorCur double precision;
BEGIN

  
  j := 1;
  FOR id_doc IN SELECT values_​​of_the_vectors.id_document FROM values_​​of_the_vectors LOOP -- проход по все таблице
    cos := 0;
    part_of_the_denominatorIn :=0;
    part_of_the_denominatorCur :=0;
colname := 'c1';
    FOR i IN 1..array_upper(val_index, 1) LOOP
     indexCompare := val_index[i];
     valueVectorIn := val_vector[indexCompare];
     EXECUTE 'SELECT '|| quote_ident(colname) || ' FROM values_​​of_the_vectors where id_document=id_doc' INTO valueVectorCur;
     colname:=REPLACE(colname, CAST(i AS CHAR(1)), CAST((i+1) AS CHAR(1)));

     cos := cos + valueVectorInvalueVectorCur;
     part_of_the_denominatorIn := part_of_the_denominatorIn + valueVectorIn*valueVectorIn;
     part_of_the_denominatorCur := part_of_the_denominatorCur + valueVectorCur*valueVectorCur;
     
    END LOOP;
    
    cos := cos/sqrt(part_of_the_denominatorIn);
    cos := cos/sqrt(part_of_the_denominatorCur);
    
    IF (1 - cos)<delta THEN
  result[j] := id_document;
  j := j+1;
    END IF;
  END LOOP;
  
  RETURN result; 
END
$BODY$
LANGUAGE plpgsql;