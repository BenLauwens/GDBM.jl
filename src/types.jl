using Compat

struct DBM
  filename :: String
  handle :: Ptr{Cvoid}
  DBM(filename::String, flag::String="c") = new(filename, gdbm_open(filename, flag))
end

Base.close(dbm::DBM) = gdbm_close(dbm)

Base.show(io::IO, dbm::DBM) = print(io, "DBM(<$(dbm.filename)>)")

struct Datum
  dptr :: Ptr{Int8}
  dsize :: Int32
end

const OPENFLAGS = Dict("r"=>0, "w"=>1, "c"=>2, "n"=>3)

const STOREFLAGS = Dict("r"=>1, "i"=>0)

Base.cconvert(::Type{Datum}, v::Tuple) = (Base.cconvert(Ptr{Int8}, v[1]), v[2])

Base.unsafe_convert(::Type{Datum}, v::Tuple) = Datum(Base.unsafe_convert(Ptr{Int8}, v[1]), v[2])