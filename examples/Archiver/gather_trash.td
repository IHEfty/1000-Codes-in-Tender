import "os"
import "strings"
import "zip"
import "path"
import "io"
import "times"

dir := "./../../DCIM/Screenshots"
dir_out := "./../../SS_Archive"
files := os.read_dir(dir)
os.mkdir(dir_out, 0755)
debug(files.length)
//w := zip.writer()
for i, file in files {
  if strings.has_prefix(file.name, ".trashed") {
   // data := io.readfile(path.join(dir, file.name))
    //w.create(file.name, data)
   // break
  // os.copy(path.join(dir, file.name), path.join(dir_out, file.name))
  // os.remove(path.join(dir, file.name))
   println(i, file.name)
  }
  
}
//w.close()
//name := times.time_format(time(),"2006-01-02T15.04.05Z07.00.zip")
//io.writefile(path.join(dir_out,name), w.bytes())
