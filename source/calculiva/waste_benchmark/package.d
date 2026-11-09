/**
 * Read-only lookup of the summary table of the Calculiva plank waste study v1.0.0
 * (doi:10.7910/DVN/8VL3MW). Computes nothing; the layout engine is not included.
 * Code: MIT. Data: CC BY 4.0, see data.d for the attribution.
 */
module calculiva.waste_benchmark;

public import calculiva.waste_benchmark.types;
public import calculiva.waste_benchmark.data : datasetVersion;
import calculiva.waste_benchmark.data : summaryRows;

/// Allowances covered by the study, percent.
immutable int[4] allowances = [5, 8, 10, 15];

/// All 42 rows, in the order of summary.csv.
immutable(WasteRow)[] rows() @safe pure nothrow @nogc
{
    return summaryRows;
}

/// Row for a format, offset ("0", "1/2", "1/3"), reuse flag and kerf in mm; null when absent.
immutable(WasteRow)* lookup(string formatId, string offset, bool reuse, int kerfMm) @trusted pure nothrow @nogc
{
    foreach (ref r; summaryRows)
        if (r.formatId == formatId && r.offset == offset && r.reuse == reuse && r.kerfMm == kerfMm)
            return &r;
    return null;
}

/// Share of rooms (percent) where a flat allowance of 5, 8, 10 or 15 % orders less than the engine count.
/// Throws an Exception for any other allowance.
double shortfallPct(const ref WasteRow row, int allowance) @safe pure
{
    foreach (ref o; row.outcomes)
        if (o.allowancePct == allowance)
            return o.shortPct;
    throw new Exception("allowance must be 5, 8, 10 or 15");
}
