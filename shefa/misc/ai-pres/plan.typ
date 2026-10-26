= Part 1: MENACE (Basic AI Concepts)
Concepts: Random-noise piles of numbers, that combine to make a decision, and that get closer to good decisions by looking at examples, and making parts that made bad decisions less important and good decisions more important, effectively polishing the random noise into decision making by nudging towards example.
Slides (Stuff in parenthesis is notes, each item is a slide move):
+ Pure black background. (Waiting to start)
+ Image of me holding a matchbox (This matchbox learned to play tic-tac-toe).
+ Zoom in  to the marking on the box: it is a tic-tac-toe game state (This box encodes this state).
+ AI-generated image of a table with 300+ of  them (There is one for every game state)
+ Video of me opening the box, containing multiple colorful beads.
+ In the last frame, the beads are segmented using OpenCV, maybe with human help (beforhand), and then there is a animation of the beads going from the box to a tic-tac-toe grid, each cell with a transparent background in the bead's color (Each bead signifies one cell).
+ Animation of a trivial game: In a animated tic-tac-toe board, using a randomly generated sequence of moves, where the human always plays the best move and the bot plays a random move. This is a situation where a human trivially wins: He just places 3 in a row one by one. Generate the random moves by this criteria specifically before rendering we write a X or O for a human move, show a video of me shaking the box and opening it, again with the openCV segmentation we take using animation a bead out and make it morph into a X or O on the correct board position corresponding to the bead (still transparent background per cell of the bead color). The game plays out, and the human's 3 in a row is marked.
+ Confetti is thrown (For the human win).
+ Highlighting the losing move for the AI, both on the board, and on the segmented beads in the image of them (The bead which caused it).
+ Removing the bead using image manipulation.
+ Replaying the game in fast-forward, then pausing when we reach the previous losing move.
+ This time, a differant move is played, delaying the loss.
+ The human ultimately wins again.
+ Fade to black.
+ A Number line is drawn, with no numbers. A human Icon is drawn on the right side, and a AI icon on the left.
+ On the side, a highly fast-forwarded version of this example of learning from a game plays. On the bottom, a image of the matchbox has it's beads rearranged. The ai moves a bit of the way to the human, but still far.
+ The learning example video plays on the side in loops, extremely fast, effectively blurring from speed, the beads are rearranged and swapped and added really fast, and the AI icon moves to the human icon on the line in a steady pace.
= Part 2: Multilayer Perceptron (Digit Recognition)

= Part 3: Transformers (Overview)
