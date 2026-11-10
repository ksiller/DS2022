"""Train a small linear model on random data and log which device was used.

Usage:
    python train.py
"""
import logging
import sys

import torch

logger = logging.getLogger(__name__)

EPOCHS = 100
LEARNING_RATE = 0.1
SAMPLES = 10_000
FEATURES = 100
SEED = 0


def get_device():
    """Use the GPU if PyTorch can see one, otherwise the CPU."""
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    logger.info("PyTorch %s, device: %s", torch.__version__, device)
    if device.type == "cuda":
        logger.info("GPU: %s", torch.cuda.get_device_name(device))
    return device


def make_data(samples, features, device):
    """Random inputs X and targets y = X @ w + noise."""
    X = torch.randn(samples, features, device=device)
    w = torch.randn(features, 1, device=device)
    y = X @ w + 0.1 * torch.randn(samples, 1, device=device)
    return X, y


def train(X, y, epochs, lr):
    """Fit a linear model with gradient descent; return the final loss."""
    model = torch.nn.Linear(X.shape[1], 1).to(X.device)
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    loss_fn = torch.nn.MSELoss()
    log_every = max(1, epochs // 5)
    for epoch in range(1, epochs + 1):
        optimizer.zero_grad()
        loss = loss_fn(model(X), y)
        loss.backward()
        optimizer.step()
        if epoch % log_every == 0 or epoch == epochs:
            logger.info("epoch %4d  loss %.4f", epoch, loss.item())
    return loss.item()


def main():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
        stream=sys.stdout,  # Slurm writes stdout to the -o file
    )
    torch.manual_seed(SEED)
    device = get_device()
    X, y = make_data(SAMPLES, FEATURES, device)
    final_loss = train(X, y, EPOCHS, LEARNING_RATE)
    logger.info("done, final loss %.4f", final_loss)
    return 0


if __name__ == "__main__":
    sys.exit(main())
