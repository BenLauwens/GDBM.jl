Base.getindex(dbm::DBM, key::String) = gdbm_fetch(dbm, key)

Base.setindex!(dbm::DBM, value::String, key::String) = gdbm_store(dbm, key, value)

Base.start(dbm::DBM) = gdbm_firstkey(dbm)

Base.done(dbm::DBM, state::Datum) = state.dptr == C_NULL

function Base.next(dbm::DBM, prev::Datum)
  key = unsafe_string(prev.dptr, prev.dsize)
  ((key, gdbm_fetch(dbm, key)), gdbm_nextkey(dbm, prev))
end

Base.length(dbm::DBM) = gdbm_count(dbm)

Base.eltype(::Type{DBM}) = Tuple{String, String}

Base.haskey(dbm::DBM, key::String) = gdbm_exists(dbm, key)

function Base.delete!(dbm::DBM, key::String)
  gdbm_delete(dbm, key)
  dbm
end

function Base.pop!(dbm::DBM, key::String, default = nothing)
  if gdbm_exists(dbm, key)
    value = gdbm_fetch(dbm, key)
    gdbm_delete(dbm, key)
    return value
  end
  default isa String && return default
  throw(KeyError(key))
end

function Base.getkey(dbm::DBM, key::String, default::String)
  gdbm_exists(dbm, key) && key
  default
end

function Base.get(dbm::DBM, key::String, default::String)
  gdbm_exists(dbm, key) && gdbm_fetch(dbm, key)
  default
end

function Base.get!(dbm::DBM, key::String, default::String)
  gdbm_exists(dbm, key) && gdbm_fetch(dbm, key)
  gdbm_store(dbm, key, default)
  default
end