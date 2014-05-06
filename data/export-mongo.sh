OIFS=$IFS;
IFS=",";

dbname="thank-a-teacher" 

collectionArray=("publicschools" "privateschools");

for ((i=0; i<${#collectionArray[@]}; ++i));
do
    keys=`mongo $dbname --eval "rs.slaveOk();
          var keys = []; for(var key in db.${collectionArray[$i]}.findOne()) { if (key != '_id') keys.push(key); }; keys;" --quiet`;
    mongoexport --db $dbname --collection ${collectionArray[$i]} --fields "$keys" --csv --out $dbname.${collectionArray[$i]}.csv;
done

IFS=$OIFS;
