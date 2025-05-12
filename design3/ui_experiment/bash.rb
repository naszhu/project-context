for i in $(seq 1 2400); do
   if ! ls | grep -E "^1 \(${i}\)\.jpg$"; then
    echo "Missing: 1 ($i)"
  fi
done

  if ! ls | grep -q "^1 \($i\)\.jpg$"; then
ls | grep -E '^1 \([0-9]+\)\.jpg$'

# Check if the file exists in the GitHub repository folder
if ! git ls-tree -r master --name-only | grep -q "^images/1 \(${i}\)\.jpg$"; then
  echo "File 1 ($i).jpg is not in the repository (branch: master, folder: images)"
fi


fi



for i in $(seq 1 2400); do
  if ! ls | grep -qE "^1 \(${i}\)\.jpg$"; then
    echo "Missing: 1 ($i)"
  fi
done




for i in $(seq 1 2400); do
  if ! curl -s https://api.github.com/repos/naszhu/project-visualmemory-sideexp/contents/images | grep -q "\"name\": \"1 ($i).jpg\""; then
    echo "File 1 ($i).jpg is not in the repository (folder: images)"
  fi
done


Missing: 1 (6)
Missing: 1 (49)
Missing: 1 (118)
Missing: 1 (130)
Missing: 1 (313)
Missing: 1 (330)
Missing: 1 (336)
Missing: 1 (349)
Missing: 1 (355)
Missing: 1 (404)
Missing: 1 (464)
Missing: 1 (480)
Missing: 1 (569)
Missing: 1 (589)
Missing: 1 (603)
Missing: 1 (620)
Missing: 1 (724)
Missing: 1 (761)
Missing: 1 (810)
Missing: 1 (855)
Missing: 1 (975)
Missing: 1 (993)
Missing: 1 (1010)
Missing: 1 (1019)
Missing: 1 (1084)
Missing: 1 (1238)
Missing: 1 (1278)
Missing: 1 (1299)
Missing: 1 (1336)
Missing: 1 (1447)
Missing: 1 (1498)
Missing: 1 (1564)
Missing: 1 (1572)
Missing: 1 (1664)
Missing: 1 (1721)
Missing: 1 (1731)
Missing: 1 (1736)
Missing: 1 (1737)
Missing: 1 (1761)
Missing: 1 (1781)
Missing: 1 (1831)
Missing: 1 (1843)
Missing: 1 (1916)
Missing: 1 (1923)
Missing: 1 (2004)
Missing: 1 (2077)
Missing: 1 (2078)
Missing: 1 (2084)
Missing: 1 (2088)
Missing: 1 (2092)
Missing: 1 (2094)
Missing: 1 (2110)
Missing: 1 (2193)
Missing: 1 (2208)
Missing: 1 (2224)
Missing: 1 (2248)
Missing: 1 (2368)
Missing: 1 (2381)



missing_files=(
  "1 (6).jpg" "1 (49).jpg" "1 (118).jpg" "1 (130).jpg" "1 (313).jpg"
  "1 (330).jpg" "1 (336).jpg" "1 (349).jpg" "1 (355).jpg" "1 (404).jpg"
  "1 (464).jpg" "1 (480).jpg" "1 (569).jpg" "1 (589).jpg" "1 (603).jpg"
  "1 (620).jpg" "1 (724).jpg" "1 (761).jpg" "1 (810).jpg" "1 (855).jpg"
  "1 (975).jpg" "1 (993).jpg" "1 (1010).jpg" "1 (1019).jpg" "1 (1084).jpg"
  "1 (1238).jpg" "1 (1278).jpg" "1 (1299).jpg" "1 (1336).jpg" "1 (1447).jpg"
  "1 (1498).jpg" "1 (1564).jpg" "1 (1572).jpg" "1 (1664).jpg" "1 (1721).jpg"
  "1 (1731).jpg" "1 (1736).jpg" "1 (1737).jpg" "1 (1761).jpg" "1 (1781).jpg"
  "1 (1831).jpg" "1 (1843).jpg" "1 (1916).jpg" "1 (1923).jpg" "1 (2004).jpg"
  "1 (2077).jpg" "1 (2078).jpg" "1 (2084).jpg" "1 (2088).jpg" "1 (2092).jpg"
  "1 (2094).jpg" "1 (2110).jpg" "1 (2193).jpg" "1 (2208).jpg" "1 (2224).jpg"
  "1 (2248).jpg" "1 (2368).jpg" "1 (2381).jpg"
)

for file in "${missing_files[@]}"; do
  if ! git ls-tree -r master --name-only | grep -q "SIDE/img/$file"; then
    echo "File $file is not in the repository (branch: master, folder: SIDE/img)"
  fi
done
