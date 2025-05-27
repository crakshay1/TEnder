
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def cluster_positions(positions, tolerance=5):
    positions = sorted(set(positions))
    clusters = []
    current_cluster = [positions[0]]
    for pos in positions[1:]:
        if abs(pos - current_cluster[-1]) <= tolerance:
            current_cluster.append(pos)
        else:
            clusters.append(current_cluster)
            current_cluster = [pos]
    clusters.append(current_cluster)
    return [int(np.mean(cluster)) for cluster in clusters]

def read_blast_output(filepath):
    columns = [
        "query_id", "subject_id", "pct_identity", "align_length", "mismatches", "gap_opens",
        "q_start", "q_end", "s_start", "s_end", "evalue", "bit_score"
    ]
    df = pd.read_csv(filepath, sep="\t", comment="#", names=columns)
    df["subject_id"] = df["subject_id"].str.strip()
    return df

def plot_grouped_alignments(df, query_name="Query"):
    grouped = df.groupby("subject_id")
    figs = []

    for subject_id, group in grouped:
        fig, ax = plt.subplots(figsize=(12, 6))

        q_min = df[["q_start", "q_end"]].values.min()
        q_max = df[["q_start", "q_end"]].values.max()
        s_min = group[["s_start", "s_end"]].values.min()
        s_max = group[["s_start", "s_end"]].values.max()
        x_max = max(q_max, s_max) + 100
        name_x_pos = q_min - 150

        # Draw reference lines
        ax.hlines(y=1, xmin=q_min, xmax=q_max, color="black", linewidth=2)
        ax.hlines(y=0, xmin=s_min, xmax=s_max, color="black", linewidth=2)

        # TE names
        ax.text(name_x_pos, 1, query_name, fontsize=10, verticalalignment='center', ha='right')
        ax.text(name_x_pos, 0, subject_id, fontsize=10, verticalalignment='center', ha='right')

        # Clustered positions for labels
        q_positions = list(group["q_start"]) + list(group["q_end"])
        s_positions = list(group["s_start"]) + list(group["s_end"])

        clustered_q = cluster_positions(q_positions)
        clustered_s = cluster_positions(s_positions)

        # Draw alignments and gather identity strings
        identity_descriptions = []
        for j, (_, row) in enumerate(group.iterrows()):
            color = "blue" if row.pct_identity >= 99 else "green" if row.pct_identity >= 98 else "red"
            ax.plot([row.q_start, row.s_start], [1, 0], linestyle="--", color=color, linewidth=2)
            ax.plot([row.q_end, row.s_end], [1, 0], linestyle="--", color=color, linewidth=2)
            identity_descriptions.append(
                f"{int(row.q_start)}–{int(row.q_end)} → {int(row.s_start)}–{int(row.s_end)} = {row.pct_identity:.2f}%"
            )

        # Label clustered positions (query)
        for i, pos in enumerate(clustered_q):
            ax.text(pos, 1.1 + (i % 5) * 0.25, str(pos), fontsize=7, ha='center')

        # Label clustered positions (subject)
        for i, pos in enumerate(clustered_s):
            ax.text(pos, -0.3 - (i % 5) * 0.25, str(pos), fontsize=7, ha='center')

        # Format plot
        ax.set_xlim(name_x_pos - 50, x_max)
        ax.set_ylim(-2.5, 3.5)
        ax.axis("off")
        ax.set_title(f"Alignements BLASTN — {query_name} vs {subject_id}", fontsize=13)

        # Caption and identity legend
        ax.text(x_max / 2, 3.3, "⚠️ Les positions proches (±5 pb) sont regroupées sur chaque ligne séparément.",
                fontsize=8, color="gray", ha="center")
        ax.text(x_max / 2, -2.2, "Correspondance des alignements (référence → copie) et pourcentage d'identité :", 
        fontsize=8, color="black", ha="center", style="italic")

        for i, desc in enumerate(identity_descriptions):
            ax.text(x_max / 2, -2.4 - i * 0.15, desc, fontsize=7, ha='center', color="black")

        figs.append(fig)

    return figs

if __name__ == "__main__":
    df = read_blast_output("SIMPLEGUY1_res.txt")
    figs = plot_grouped_alignments(df, query_name="SIMPLEGUY1")
    for i, fig in enumerate(figs):
        fig.savefig(f"SIMPLEGUY1_vs_{i+1}.png")
