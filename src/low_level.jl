using Compat

function gdbm_open(name::String, flag::String="r")
  handle = ccall((:gdbm_open, "libgdbm"), Ptr{Cvoid}, (Cstring, Int32, Int32, Int32, Ptr{Cvoid}), name, 0, OPENFLAGS[flag], 420, C_NULL)
  handle == C_NULL && error("File could not be opened!")
  handle
end

function gdbm_close(dbm::DBM)
  ccall((:gdbm_close, "libgdbm"), Cvoid, (Ptr{Cvoid},), dbm.handle)
end

function gdbm_store(dbm::DBM, key::String, value::String, flag::String="r")
  ret = ccall((:gdbm_store, "libgdbm"), Int32, (Ptr{Cvoid}, Datum, Datum, Int32), dbm.handle, (key, length(key)), (value, length(value)), STOREFLAGS[flag])
  ret == -1 && println("Not stored: database is not writable or key/value is an empty string.")
  ret == 1 && println("Not stored: key is already in database.")
  nothing
end

function gdbm_fetch(dbm::DBM, key::String)
  datum = ccall((:gdbm_fetch, "libgdbm"), Datum, (Ptr{Cvoid}, Datum), dbm.handle, (key, length(key)))
  datum.dptr ≠ C_NULL && return unsafe_string(datum.dptr, datum.dsize)
  println("Key not found.")
end

function gdbm_exists(dbm::DBM, key::String)
  ret = ccall((:gdbm_exists, "libgdbm"), Int32, (Ptr{Cvoid}, Datum), dbm.handle, (key, length(key)))
  ret == 0 && return false
  true
end

function gdbm_count(dbm::DBM)
  count = Ref(UInt(0))
  ret = ccall((:gdbm_count, "libgdbm"), Int32, (Ptr{Cvoid}, Ref{UInt}), dbm.handle, count)
  ret == -1 && error("Error reading database.")
  Int(count[])
end

function gdbm_delete(dbm::DBM, key::String)
  ret = ccall((:gdbm_delete, "libgdbm"), Int32, (Ptr{Cvoid}, Datum), dbm.handle, (key, length(key)))
  ret == 0 && return
  println("Not deleted: database is not writable or key not found.")
end

function gdbm_firstkey(dbm::DBM)
  ccall((:gdbm_firstkey, "libgdbm"), Datum, (Ptr{Cvoid}, ), dbm.handle)
end

function gdbm_nextkey(dbm::DBM, prev::Datum)
  ccall((:gdbm_nextkey, "libgdbm"), Datum, (Ptr{Cvoid}, Datum), dbm.handle, prev)
end