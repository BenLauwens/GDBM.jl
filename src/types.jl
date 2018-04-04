using Compat

struct DBM
  filename :: String
  handle :: Ptr{Cvoid}
  DBM(filename::String, flag::String="c") = new(filename, gdbm_open(filename, flag))
end

Base.close(dbm::DBM) = gdbm_close(dbm.handle)

Base.show(io::IO, dbm::DBM) = print(io, "DBM(<$(dbm.filename)>)")

struct Datum
  dptr :: Ptr{Int8}
  dsize :: Int32
  Datum(str::String) = new(Base.unsafe_convert(Ptr{Int8}, str), length(str))
end

const OPENFLAGS = Dict("r"=>0, "w"=>1, "c"=>2, "n"=>3)

const STOREFLAGS = Dict("r"=>1, "i"=>0)