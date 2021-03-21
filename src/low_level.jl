using Compat

function gdbm_open(name::String, flag::String="r")
  handle = ccall((:gdbm_open, libgdbm), Ptr{Cvoid}, (Cstring, Int32, Int32, Int32, Ptr{Cvoid}), name, 0, OPENFLAGS[flag], 420, C_NULL)
  handle == C_NULL && error("File could not be opened!")
  handle
end

function gdbm_close(handle::Ptr{Cvoid})
  ccall((:gdbm_close, libgdbm), Cvoid, (Ptr{Cvoid},), handle)
end

function gdbm_store(handle::Ptr{Cvoid}, key::Datum, value::Datum, flag::String="r")
  ret = ccall((:gdbm_store, libgdbm), Int32, (Ptr{Cvoid}, Datum, Datum, Int32), handle, key, value, STOREFLAGS[flag])
  ret == -1 && error("Database is not writable or key/value is not a valid string.")
  ret == 1 && error("Key is already in database.")
  nothing
end

function gdbm_fetch(handle::Ptr{Cvoid}, key::Datum)
  datum = ccall((:gdbm_fetch, libgdbm), Datum, (Ptr{Cvoid}, Datum), handle, key)
  datum.dptr == C_NULL && throw(KeyError(key))
  datum
end

function gdbm_exists(handle::Ptr{Cvoid}, key::Datum)
  ret = ccall((:gdbm_exists, libgdbm), Int32, (Ptr{Cvoid}, Datum), handle, key)
  ret == 0 && return false
  true
end

function gdbm_count(handle::Ptr{Cvoid})
  count = Ref(UInt(0))
  ret = ccall((:gdbm_count, libgdbm), Int32, (Ptr{Cvoid}, Ref{UInt}), handle, count)
  ret == -1 && error("Error reading database.")
  Int(count[])
end

function gdbm_delete(handle::Ptr{Cvoid}, key::Datum)
  ret = ccall((:gdbm_delete, libgdbm), Int32, (Ptr{Cvoid}, Datum), handle, key)
  ret ≠ 0 && error("Database is not writable or key not found.")
  nothing
end

function gdbm_firstkey(handle::Ptr{Cvoid})
  ccall((:gdbm_firstkey, libgdbm), Datum, (Ptr{Cvoid}, ), handle)
end

function gdbm_nextkey(handle::Ptr{Cvoid}, prev::Datum)
  ccall((:gdbm_nextkey, libgdbm), Datum, (Ptr{Cvoid}, Datum), handle, prev)
end

function libc_free(ptr::Ptr{UInt8})
  ccall((:free, "libc"), Cvoid, (Ptr{UInt8}, ), ptr)
end