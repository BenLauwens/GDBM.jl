# GDBM

Wrapper for the library GDBM. Implements partially the interface of associative collections.

[![Build Status](https://travis-ci.org/benlauwens/GDBM.jl.svg?branch=master)](https://travis-ci.org/benlauwens/GDBM.jl)

[![Coverage Status](https://coveralls.io/repos/benlauwens/GDBM.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/benlauwens/GDBM.jl?branch=master)

[![codecov.io](http://codecov.io/github/benlauwens/GDBM.jl/coverage.svg?branch=master)](http://codecov.io/github/benlauwens/GDBM.jl?branch=master)

```julia
julia> using GDBM

julia> db = DBM("example.db")
DBM(<example.db>)

julia> for i in 1:5
         db["key $i"] = "val $i"
       end

julia> for (key, value) in db
         println(key, ", ", value)
       end
key 5, val 5
key 4, val 4
key 3, val 3
key 2, val 2
key 1, val 1
```

