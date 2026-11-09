/**
 * vectors.json is generated from summary.csv by tools/ports/gen_waste_benchmark.py (calculiva repository).
 * The tests compare the whole D table to it; no value is typed by hand. Run: dub test
 */
module waste_benchmark_test;

import std.exception : assertThrown;
import std.json : JSONType, JSONValue, parseJSON;
import std.math : fabs;
import calculiva.waste_benchmark;

private double num(const JSONValue j)
{
    switch (j.type)
    {
    case JSONType.float_: return j.floating;
    case JSONType.integer: return j.integer;
    case JSONType.uinteger: return j.uinteger;
    default: assert(0, "not a number");
    }
}

private void close(double a, double b)
{
    assert(fabs(a - b) < 1e-9);
}

unittest
{
    const v = parseJSON(import("vectors.json"));
    assert(datasetVersion == v["dataset_version"].str);
    assert(rows.length == v["count"].integer);
    foreach (i, a; v["allowances"].array)
        assert(allowances[i] == a.integer);

    foreach (i, jr; v["rows"].array)
    {
        auto r = lookup(jr["format_id"].str, jr["offset"].str, jr["reuse"].boolean, cast(int) jr["kerf_mm"].integer);
        assert(r !is null);
        assert(r is &rows[i]);
        assert(r.formatOrigin == jr["format_origin"].str);
        assert(r.referenceOnly == jr["reference_only"].boolean);
        assert(r.cases == jr["cases"].integer);
        const w = jr["waste_pct"].array;
        close(r.wasteMin, num(w[0]));
        close(r.wasteMedian, num(w[1]));
        close(r.wasteMean, num(w[2]));
        close(r.wasteMax, num(w[3]));
        foreach (k, ja; jr["allowances"].array)
        {
            const o = r.outcomes[k];
            assert(o.allowancePct == ja["allowance"].integer);
            assert(o.shortCount == ja["short"].integer);
            assert(o.exactCount == ja["exact"].integer);
            assert(o.excessCount == ja["excess"].integer);
            close(o.excessPct, num(ja["excess_pct"]));
            close(shortfallPct(*r, cast(int) ja["allowance"].integer), num(ja["short_pct"]));
        }
        foreach (bad; v["invalid_allowances"].array)
            assertThrown(shortfallPct(*r, cast(int) bad.integer));
    }

    foreach (m; v["missing_keys"].array)
        assert(lookup(m["format_id"].str, m["offset"].str, m["reuse"].boolean, cast(int) m["kerf_mm"].integer) is null);
}
