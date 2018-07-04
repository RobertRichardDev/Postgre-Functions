/*
 Take two table names (through the `regtable` type),
 build a query comparing their contents, execute it, and
 return a set of diff-like results with the rows that differ.
*/
CREATE FUNCTION diff_tables(t1 regclass, t2 regclass) 
 returns TABLE("+/-" text, line text)
AS $func$
BEGIN
  RETURN QUERY EXECUTE format($$
   SELECT '+', d1.*::text FROM (
    SELECT * FROM %s
     EXCEPT
    SELECT * FROM %s) AS d1
   UNION ALL
   SELECT '-', d2.*::text FROM (
    SELECT * FROM %s
     EXCEPT
    SELECT * FROM %s) AS d2
   $$, t2, t1, t1, t2);
END
$func$ language plpgsql;
