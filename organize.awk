NR == 1 {
    out = $1
}
{
    prev = out
    out = out OFS $2
    if ( length(out) > 256 ) {
        print prev
        out = $0
    }
}
END {
    print out
}
