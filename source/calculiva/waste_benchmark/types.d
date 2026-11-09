// Code: MIT. Data types of the Calculiva plank waste study summary table.
module calculiva.waste_benchmark.types;

/// Outcome of one flat waste allowance over the 1,369 rooms of a group.
struct AllowanceOutcome
{
    int allowancePct;   /// 5, 8, 10 or 15
    int shortCount;     /// rooms where the order is below the engine-counted source planks
    int exactCount;     /// rooms where the order matches exactly
    int excessCount;    /// rooms where the order is above
    double shortPct;    /// shortCount / cases, percent (as published)
    double excessPct;   /// excessCount / cases, percent (as published)
}

/// One row of summary.csv: a plank format, row offset, offcut reuse and saw kerf.
struct WasteRow
{
    string formatId;     /// e.g. "48x7.5in"
    string formatOrigin; /// calculator_preset, parametric or register_observation
    string offset;       /// "0", "1/2" or "1/3"
    bool reuse;          /// offcut reuse on (false = worst case)
    int kerfMm;          /// saw kerf, mm
    bool referenceOnly;  /// true for offset 0 (not an installation pattern)
    int cases;           /// rooms in the group
    double wasteMin, wasteMedian, wasteMean, wasteMax; /// waste_pct statistics, percent
    AllowanceOutcome[4] outcomes; /// allowances 5, 8, 10, 15 in that order
}
